module Boxcutter::LoadBalancer
  class Service
    include Boxcutter::Logging

    attr_reader :api

    def initialize(api, attrs, logger = $stdout)
      @api = api
      @attrs = attrs
      @logger = logger
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
      resp = api.backends(id)

      if resp.success?
        resp.parsed.map {|attrs| Backend.new(api, attrs, logger)}
      else
        []
      end
    end

    def each_backend_named(backend_name, &block)
      results = backends.select {|backend| backend.name == backend_name}
      if !results.empty?
        results.each(&block)
      else
        log "Could not find '#{backend_name}' on '#{self}'"
      end
    end
  end
end
