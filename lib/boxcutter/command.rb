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
        if backend = service.backends.detect {|backend| backend.name == backend_name}
          if machine = backend.machines.detect {|machine| machine.hostname == hostname}
            log "Removing #{machine} from #{backend}"

            unless dryrun
              response = machine.remove!
              log "Response was: #{response.body}"
            else
              log "#{hostname} was not removed from the backend because --dryrun was specified"
            end
          else
            log "Could not find '#{hostname}' on #{backend}"
          end
        else
          log "Could not find '#{backend_name}' backend on #{service}"
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

      if machine = Boxcutter::Server.find_by_hostname("#{hostname}.blueboxgrid.com")

        app = Boxcutter::LoadBalancer::Application.all.first

        app.services.each do |service|
          if backend = service.backends.detect {|backend| backend.name == backend_name}
            log "Adding machine #{machine.hostname} to backend #{backend.name}"
            unless dryrun
              response = backend.add_machine(machine.id, :port => 80)
              log "Added #{machine.hostname} to #{backend.name} with response: #{response.body}"
            else
              log "#{machine.hostname} was not added to the backend because --dryrun was specified"
            end
          else
            log "Could not find default backend on #{service}"
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
  end
end
