require "rubygems"
require "bundler"
Bundler.setup(:default)

module Boxcutter
end

require_relative 'boxcutter/api'
require_relative 'boxcutter/server'
require_relative 'boxcutter/load_balancer'
