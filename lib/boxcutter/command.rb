module Boxcutter
  class Command
    include Boxcutter::Logging

    def initialize(logger = $stdout)
      @logger = logger
    end

    # options:
    # - :backend
    # - :hostname
    # - :dryrun
    def remove_machine(opts = {})
      backend_name = opts.fetch(:backend, 'default')
      dryrun       = opts.fetch(:dryrun, false)
      hostname     = opts.fetch(:hostname)

      app = Boxcutter::LoadBalancer::Application.all(logger).first

      app.services.each do |service|
        service.each_backend_named(backend_name) do |backend|
          backend.each_machine_named(hostname) do |machine|
            log "Removing #{machine} from #{backend}"

            unless dryrun
              response = machine.remove!
              log "Response was: #{response.body}"
            else
              log "#{hostname} was not removed from the backend because --dryrun was specified"
            end
          end
        end
      end
    end

    # options:
    # - :backend
    # - :hostname
    # - :dryrun
    def add_machine(opts = {})
      backend_name = opts.fetch(:backend, 'default')
      dryrun       = opts.fetch(:dryrun, false)
      hostname     = opts.fetch(:hostname)

      if server = Boxcutter::Server.find_by_hostname("#{hostname}.blueboxgrid.com")

        app = Boxcutter::LoadBalancer::Application.all.first

        app.services.each do |service|
          service.each_backend_named(backend_name) do |backend|
            log "Adding server #{server.hostname} to backend #{backend.name}"
            unless dryrun
              response = backend.add_machine(server.id, :port => 80)
              log "Added #{server.hostname} to #{backend.name} with response: #{response.body}"
            else
              log "#{server.hostname} was not added to the backend because --dryrun was specified"
            end
          end
        end
      else
        log "Could not find server '#{hostname}' on BlueBoxGroup"
      end
    end
  end
end
