module Boxcutter
  class Command
    # options:
    # - :backend
    # - :hostname
    # - :dryrun
    def self.remove_machine(opts = {})
      app = Boxcutter::LoadBalancer::Application.all.first

      app.services.each do |service|
        if backend = service.backends.detect {|backend| backend.name == opts[:backend]}
          if machine = backend.machines.detect {|machine| machine.hostname == opts[:hostname]}
            puts "Removing #{machine} from #{backend}"

            unless opts[:dryrun]
              response = machine.remove!
              puts "Response was: #{response}"
            else
              puts "#{opts[:hostname]} was not removed from the backend because --dryrun was specified"
            end
          else
            puts "Could not find '#{opts[:hostname]}' on #{backend}"
          end
        else
          puts "Could not find '#{opts[:backend]}' backend on #{service}"
        end
      end
    end

    # options:
    # - :backend
    # - :hostname
    # - :dryrun
    def self.add_machine(opts = {})
      if machine = Boxcutter::Server.find_by_hostname("#{opts[:hostname]}.blueboxgrid.com")

        app = Boxcutter::LoadBalancer::Application.all.first

        app.services.each do |service|
          if backend = service.backends.detect {|backend| backend.name == opts[:backend]}
            puts "Adding machine #{machine.hostname} to backend #{backend.name}"
            unless opts[:dryrun]
              response = backend.add_machine(machine.id, :port => port)
              puts "Added #{machine.hostname} to #{backend.name} with response: #{response}"
            else
              puts "#{machine.hostname} was not added to the backend because --dryrun was specified"
            end
          else
            puts "Could not find default backend on #{service}"
          end
        end
      else
        puts "Could not find server '#{opts[:hostname]}' on BlueBoxGroup"
      end
    end
  end
end
