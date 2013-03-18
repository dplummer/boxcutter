module Boxcutter
  class Server
    def self.all
      api = Api.new(*ENV['BBG_API_KEY'].split(':'))
      resp = api.servers

      if resp.success?
        resp.parsed.map {|attrs| new(api, attrs)}
      else
        []
      end
    end

    def self.find_by_hostname(hostname)
      all.detect {|server| server.hostname == hostname}
    end

    attr_reader :api

    def initialize(api, attrs)
      @api = api
      @attrs = attrs
    end

    def to_s
      "#<Server id:'#{id}' hostname:'#{hostname}' description:'#{description}' status:'#{status}'>"
    end

    def ips
      @attrs["ips"].map {|ip| ip["address"]}
    end

    def memory
      @attrs["memory"]
    end

    def id
      @attrs["id"]
    end

    def storage
      @attrs["storage"]
    end

    def location_id
      @attrs["location_id"]
    end

    def hostname
      @attrs["hostname"]
    end

    def description
      @attrs["description"]
    end

    def cpu
      @attrs["cpu"]
    end

    def status
      @attrs["status"]
    end

    def lb_applications
      @attrs["lb_applications"].map do |lb_app_attrs|
        LoadBalancer::Application.find(lb_app_attrs["lb_application_id"], api)
      end
    end
  end
end
