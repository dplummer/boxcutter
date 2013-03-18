module Boxcutter::LoadBalancer
  class Application
    include Boxcutter::Logging

    def self.all(logger = $stdout)
      api = ::Boxcutter::Api.new(*ENV['BBG_API_KEY'].split(':'))
      resp = api.applications

      if resp.success?
        resp.parsed.map {|attrs| new(api, attrs, logger)}
      else
        []
      end
    end

    def self.find(id, api = nil)
      api = ::Boxcutter::Api.new(*ENV['BBG_API_KEY'].split(':')) if api.nil?
      resp = api.application(id)

      if resp.success?
        new(api, resp.parsed)
      end
    end

    attr_reader :api

    def initialize(api, attrs, logger = $stdout)
      @api = api
      @attrs = attrs
      @logger = logger
    end

    def to_s
      "#<Application id:'#{id}' name:'#{name}' ip_v4:'#{ip_v4}' ip_v6:'#{ip_v6}'>"
    end

    def id
      @attrs["id"]
    end

    def ip_v4
      @attrs["ip_v4"]
    end

    def ip_v6
      @attrs["ip_v6"]
    end

    def name
      @attrs["name"]
    end

    def services
      resp = api.services(id)

      if resp.success?
        resp.parsed.map {|attrs| Service.new(api, attrs, logger)}
      else
        []
      end
    end
  end
end
