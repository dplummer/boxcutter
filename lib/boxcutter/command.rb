module Boxcutter
  class Command
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

      app = Boxcutter::LoadBalancer::Application.all.first

      app.services.each do |service|
        each_backend_named(service, backend_name) do |backend|
        #if backend = service.backends.detect {|backend| backend.name == backend_name}
          each_machine_named(backend, hostname) do |machine|
          #if machine = backend.machines.detect {|machine| machine.hostname == hostname}
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
          if backend = service.backends.detect {|backend| backend.name == backend_name}
            log "Adding server #{server.hostname} to backend #{backend.name}"
            unless dryrun
              response = backend.add_server(server.id, :port => 80)
              log "Added #{server.hostname} to #{backend.name} with response: #{response.body}"
            else
              log "#{server.hostname} was not added to the backend because --dryrun was specified"
            end
          else
            log "Could not find '#{backend_name}' backend on '#{service.name}'"
          end
        end
      else
        log "Could not find server '#{hostname}' on BlueBoxGroup"
      end
    end

    private
    def log(msg)
      @logger.puts msg
    end

    # move to service?
    def each_backend_named(service, backend_name, &block)
      backends = service.backends.select {|backend| backend.name == backend_name}
      if !backends.empty?
        backends.each(&block)
      else
        log "Could not find '#{backend_name}' on '#{service}'"
      end
    end

    # move to backend?
    def each_machine_named(backend, hostname, &block)
      machines = backend.machines.select {|machine| machine.hostname == hostname}.
                                  each(&block)
      if !machines.empty?
        machines.each(&block)
      else
        log "Could not find '#{hostname}' on '#{backend}'"
      end
    end

  end
end
