require "rubygems"
require "bundler"
Bundler.require(:default)

module BlueBoxGroup
end

require_relative 'blue_box_group/api'
require_relative 'blue_box_group/server'
require_relative 'blue_box_group/load_balancer'
