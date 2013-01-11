module Boxcutter::LoadBalancer
  class Machine
    include Boxcutter::Logging

    attr_reader :api, :backend

    def initialize(backend, api, attrs, logger = $stdout)
      @backend = backend
      @api = api
      @attrs = attrs
      @logger = logger
    end

    def to_s
      "#<Machine id:'#{id}' backend_id:'#{backend.id}' hostname:'#{hostname}' ip:'#{ip}' port:'#{port}'>"
    end

    def port
      @attrs["port"]
    end

    def ip
      @attrs["ip"]
    end

    def id
      @attrs["id"]
    end

    def hostname
      @attrs["hostname"]
    end

    def remove!
      backend.remove_machine(id)
    end

    def add!
      backend.add_machine(id)
    end
  end
end
