#!/usr/bin/env ruby
require File.dirname(__FILE__) + '/../lib/boxcutter'
require 'trollop'

opts = Trollop::options do
  opt :backend, "Service backend name", :type => String, :default => 'default'
  opt :hostname, "Machine hostname to remove", :type => String, :short => 'n'
  opt :dryrun, "Don't actually remove the server from the backend"
  opt :app_id, "Application ID to remove the machine from", :type => String
end

if opts[:hostname].nil? || opts[:hostname].empty?
  Trollop::die :hostname, "You must specify the hostname with -n" 
end

cmd = Boxcutter::Command.new
cmd.remove_machine(opts)
