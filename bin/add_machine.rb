#!/usr/bin/env ruby
require_relative '../lib/boxcutter'
require 'trollop'

opts = Trollop::options do
  opt :backend, "Service backend name", :type => String, :default => 'default'
  opt :hostname, "Machine hostname to add", :type => String, :short => 'n'
  opt :dryrun, "Don't actually add the server to the backend"
end

$dryrun = opts[:dryrun]

if opts[:hostname].nil? || opts[:hostname].empty?
  Trollop::die :hostname, "You must specify the hostname with -n" 
end

def add_machine_to_service(machine, service, port, backend_name = 'default')
  if backend = service.backends.detect {|backend| backend.name == backend_name}
    puts "Adding machine #{machine.hostname} to backend #{backend.name}"
    unless $dryrun
      response = backend.add_machine(machine.id, :port => port)
      puts "Added #{machine.hostname} to #{backend.name} with response: #{response}"
    else
      puts "#{machine.hostname} was not added to the backend because --dryrun was specified"
    end
  else
    puts "Could not find default backend on #{service}"
  end
end

if machine = Boxcutter::Server.find_by_hostname("#{opts[:hostname]}.blueboxgrid.com")

  app = Boxcutter::LoadBalancer::Application.all.first

  services = app.services
  http_service = services.detect(&:http?)
  https_service = services.detect(&:https?)

  add_machine_to_service(machine, http_service, 80, opts[:backend])
  add_machine_to_service(machine, https_service, 80, opts[:backend])
else
  puts "Could not find server '#{opts[:hostname]}' on BlueBoxGroup"
end
