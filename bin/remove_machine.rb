#!/usr/bin/env ruby
require_relative '../lib/boxcutter'
require 'trollop'

opts = Trollop::options do
  opt :backend, "Service backend name", :type => String, :default => 'default'
  opt :hostname, "Machine hostname to remove", :type => String, :short => 'n'
  opt :dryrun, "Don't actually remove the server from the backend"
end

if opts[:hostname].nil? || opts[:hostname].empty?
  Trollop::die :hostname, "You must specify the hostname with -n" 
end

Boxcutter::Command.remove_machine(opts)
