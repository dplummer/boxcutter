module BlueBoxGroup::LoadBalancer
  class Backend
    attr_reader :api

    def initialize(api, attrs)
      @api = api
      @attrs = attrs
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
      api.machines(id).map {|attrs| Machine.new(api, attrs)}
    end

    def remove_machine(machine_id)
      api.delete_machine(id, machine_id)
    end
  end
end
