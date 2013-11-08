module MercadoPago

  module Recurrent

    def self.create_recurrent_preference(access_token, data)
      payload = JSON.generate(data)
      headers = { content_type: 'application/json', accept: 'application/json' }
      MercadoPago::Request.wrap_post("/preapproval?access_token=#{access_token}", payload, headers)
    end

    def self.get_recurrent_preference(access_token, preference_id)
      headers = { accept: 'application/json' }
      MercadoPago::Request.wrap_get("/preapproval/#{preference_id}?access_token=#{access_token}")
    end

    def self.update_recurrent_preference(access_token, preference_id, data)
      payload = JSON.generate(data)
      headers = { content_type: 'application/json', accept: 'application/json' }
      MercadoPago::Request.wrap_put("/preapproval/#{preference_id}?access_token=#{access_token}", payload, headers)
    end

    def self.cancel_recurrent_preference(access_token, preference_id)
      data = { "status" => "cancelled" }
      payload = JSON.generate(data)
      headers = { content_type: 'application/json', accept: 'application/json' }
      MercadoPago::Request.wrap_put("/preapproval/#{preference_id}?access_token=#{access_token}", payload, headers)
    end

  end

end
