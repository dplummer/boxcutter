#!/usr/bin/env ruby
require_relative '../lib/boxcutter'
require 'trollop'

opts = Trollop::options do
  opt :backend, "Service backend name", :type => String, :default => 'default'
  opt :hostname, "Machine hostname to remove", :type => String, :short => 'n'
  opt :dryrun, "Don't actually remove the server from the backend"
end

$dryrun = opts[:dryrun]

if opts[:hostname].nil? || opts[:hostname].empty?
  Trollop::die :hostname, "You must specify the hostname with -n" 
end

app = Boxcutter::LoadBalancer::Application.all.first

app.services.each do |service|
  if backend = service.backends.detect {|backend| backend.name == opts[:backend]}
    if app1 = backend.machines.detect {|machine| machine.hostname == opts[:hostname]}
      puts "Removing #{app1} from #{backend}"

      unless $dryrun
        response = app1.remove!
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
