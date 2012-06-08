module BlueBoxGroup::LoadBalancer
  class Application
    def self.all
      api = ::BlueBoxGroup::Api.new(*ENV['BBG_API_KEY'].split(':'))
      api.applications.map {|attrs| new(api, attrs)}
    end

    def self.find(id, api = nil)
      api = ::BlueBoxGroup::Api.new(*ENV['BBG_API_KEY'].split(':')) if api.nil?
      new(api, api.application(id))
    end

    attr_reader :api

    def initialize(api, attrs)
      @api = api
      @attrs = attrs
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
      api.services(id).map {|attrs| Service.new(api, attrs)}
    end
  end
end
