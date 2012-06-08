module BlueBoxGroup
  class Api
    def initialize(customer_id, api_key_secret)
      @customer_id    = customer_id
      @api_key_secret = api_key_secret
    end

    def to_s
      "#<Api customer_id:'#{@customer_id}' api_key_secret:'***'>"
    end

    def get(path)
      conn.get(path).body
    end

    def conn
      @conn ||= Faraday.new(:url => "https://boxpanel.bluebox.net/api") do |conn|
        conn.response :json
        conn.request :url_encoded
        conn.adapter Faraday.default_adapter
        conn.basic_auth(@customer_id, @api_key_secret)
      end
    end

    def applications
      get('lb_applications')
    end

    def application(app_id)
      get("lb_applications/#{app_id}")
    end

    def services(app_id)
      get("lb_applications/#{app_id}/lb_services")
    end

    def service(app_id, service_id)
      get("lb_applications/#{app_id}/lb_services/#{service_id}")
    end

    def backends(service_id)
      get("lb_services/#{service_id}/lb_backends")
    end

    def backend(service_id, backend_id)
      get("lb_services/#{service_id}/lb_backends/#{backend_id}")
    end

    def machines(backend_id)
      get("lb_backends/#{backend_id}/lb_machines")
    end

    def machine(backend_id, machine_id)
      get("lb_backends/#{backend_id}/lb_machines/#{machine_id}")
    end

    def delete_machine(backend_id, machine_id)
      conn.delete("lb_backends/#{backend_id}/lb_machines/#{machine_id}")
    end

    # Options are:
    # port - The port the machine is serving http or https on. Defaults to the
    #        port the service is listening on.
    # weight - The multiplier for what portion of the incoming traffic should be
    #          routed to this machine.
    # maxconn - The maximum number of simultaneous connections allowed for this
    #           machine.
    # backup - Only direct traffic to this node if all the other nodes are down.
    def create_machine(backend_id, machine_id, options = {})
      data = { 'lb_machine' => machine_id }
      data['lb_options'] = options unless options.blank?
      conn.post("lb_backends/#{backend_id}/lb_machines", data)
    end

    def servers
      get("servers")
    end
  end
end
