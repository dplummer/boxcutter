module Boxcutter::LoadBalancer
  class Service
    attr_reader :api

    def initialize(api, attrs)
      @api = api
      @attrs = attrs
    end

    def to_s
      "#<Service id:'#{id}' name:'#{name}' port:'#{port}' service_type:'#{service_type}'>"
    end

    def name
      @attrs["name"]
    end

    def port
      @attrs["port"]
    end

    def id
      @attrs["id"]
    end

    def service_type
      @attrs["service_type"]
    end

    def http?
      service_type == 'http'
    end

    def https?
      service_type == 'https'
    end

    def backends
      api.backends(id).map {|attrs| Backend.new(api, attrs)}
    end
  end
end
