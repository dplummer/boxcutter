module Boxcutter::LoadBalancer
  class Backend
    include Boxcutter::Logging

    attr_reader :api

    def initialize(api, attrs, logger = $stdout)
      @api = api
      @attrs = attrs
      @logger = logger
    end

    def to_s
      "#<Backend id:'#{id}' name:'#{name}'>"
    end

    def name
      @attrs["backend_name"]
    end

    def id
      @attrs["id"]
    end

    def machines
      resp = api.machines(id)

      if resp.success?
        resp.parsed.map {|attrs| Machine.new(self, api, attrs, logger)}
      else
        []
      end
    end

    def remove_machine(machine_id)
      api.delete_machine(id, machine_id)
    end

    def add_machine(machine_id, options = {})
      api.create_machine(id, machine_id, options)
    end

    def each_machine_named(hostname, &block)
      results = machines.select {|machine| machine.hostname == hostname}
      if !results.empty?
        results.each(&block)
      else
        log "Could not find '#{hostname}' on '#{self}'"
      end
    end
  end
end
