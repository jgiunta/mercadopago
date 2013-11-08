require 'rest-client'
require 'json'

module MercadoPago

  module Request

    class ClientError < Exception
    end

    MERCADOPAGO_URL = 'https://api.mercadolibre.com'

    def self.wrap_post(path, payload, headers = {})
      raise ClientError('No data given') if payload.nil? or payload.empty?
      make_request(:post, path, payload, headers)
    end

    def self.wrap_put(path, payload, headers = {})
      raise ClientError('No data given') if payload.nil? or payload.empty?
      make_request(:put, path, payload, headers)
    end

    def self.wrap_get(path, headers = {})
      make_request(:get, path, nil, headers)
    end

    def self.make_request(type, path, payload = nil, headers = {})
      args = [type, "#{MERCADOPAGO_URL}#{path}", payload, headers].compact
      response = RestClient.send *args

      JSON.load(response)
    rescue Exception => e
      JSON.load(e.response)
    end

  end

end
