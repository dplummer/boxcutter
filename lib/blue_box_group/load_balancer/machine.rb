module BlueBoxGroup::LoadBalancer
  class Machine
    attr_reader :api

    def initialize(api, attrs)
      @api = api
      @attrs = attrs
    end

    def to_s
      "#<Machine id:'#{id}' hostname:'#{hostname}' ip:'#{ip}' port:'#{port}'>"
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
  end
end
