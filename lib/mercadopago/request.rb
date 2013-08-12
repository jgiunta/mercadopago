require 'rest-client'
require 'json'

module MercadoPago

  module Request

    class ClientError < Exception
    end

    #
    # This URL is the base for all API calls.
    #
    MERCADOPAGO_URL = 'https://api.mercadolibre.com'

    #
    # Makes a POST request to a MercaPago API.
    #
    # - path: the path of the API to be called.
    # - payload: the data to be trasmitted to the API.
    # - headers: the headers to be transmitted over the HTTP request.
    #
    def self.wrap_post(path, payload, headers = {})
      raise ClientError('No data given') if payload.nil? or payload.empty?
      make_request(:post, path, payload, headers)
    end

    #
    # Makes a GET request to a MercaPago API.
    #
    # - path: the path of the API to be called, including any query string parameters.
    # - headers: the headers to be transmitted over the HTTP request.
    #
    def self.wrap_get(path, headers = {})
      make_request(:get, path, nil, headers)
    end

    #
    # Makes a HTTP request to a MercadoPago API.
    #
    # - type: the HTTP request type (:get, :post, :put, :delete).
    # - path: the path of the API to be called.
    # - payload: the data to be trasmitted to the API.
    # - headers: the headers to be transmitted over the HTTP request.
    #
    def self.make_request(type, path, payload = nil, headers = {})
      args = [type, "#{MERCADOPAGO_URL}#{path}", payload, headers].compact
      response = RestClient.send *args

      JSON.load(response)
    rescue Exception => e
      JSON.load(e.response)
    end

  end

end
