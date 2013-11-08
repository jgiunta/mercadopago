module MercadoPago

  class AccessError < Exception
  end

  #
  # You can create a Client object to interact with a MercadoPago
  # account through the API.
  #
  # You will need client_id and client_secret. Client will save
  # the token as part of its inner state. It will use it to call
  # API methods.
  #
  # Usage example:
  #
  #  mp_client = MercadoPago::Client.new(client_id, client_secret)
  #
  #  mp_client.create_preference(data)
  #  mp_client.get_preference(preference_id)
  #  mp_client.notification(payment_id)
  #  mp_client.search(data)
  #
  class Client

    attr_reader :access_token, :refresh_token

    #
    # Creates an instance and stores the access_token to make calls to the
    # MercadoPago API.
    #
    # - client_id
    # - client_secret
    #
    def initialize(client_id, client_secret)
      load_tokens MercadoPago::Authentication.access_token(client_id, client_secret)
    end

    #
    # Refreshes an access token.
    #
    # - client_id
    # - client_secret
    #
    def refresh_access_token(client_id, client_secret)
      load_tokens MercadoPago::Authentication.refresh_access_token(client_id, client_secret, @refresh_token)
    end

    #
    # Creates a payment preference.
    #
    # - data: contains the data according to the payment preference that will be created.
    #
    def create_preference(data)
      MercadoPago::Checkout.create_preference(@access_token, data)
    end

    #
    # Returns the payment preference.
    #
    # - preference_id: the id of the payment preference that will be retrieved.
    #
    def get_preference(preference_id)
      MercadoPago::Checkout.get_preference(@access_token, preference_id)
    end

    # Creates a recurrent preference
    def create_recurrent_preference(data)
      MercadoPago::Recurrent.create_recurrent_preference(@access_token, data)
    end

    def get_recurrent_preference(preference_id)
      MercadoPago::Recurrent.get_recurrent_preference(@access_token, preference_id)
    end

    def update_recurrent_preference(preference_id, data)
      MercadoPago::Recurrent.update_recurrent_preference(@access_token, preference_id, data)
    end

    def cancel_recurrent_preference(preference_id)
      MercadoPago::Recurrent.cancel_recurrent_preference(@access_token, preference_id)
    end

    #
    # Retrieves the latest information about a payment.
    #
    # - payment_id: the id of the payment to be checked.
    #
    def notification(payment_id)
      MercadoPago::Collection.notification(@access_token, payment_id)
    end

    #
    # Searches for collections that matches some of the search hash criteria.
    #
    # - search_hash: the search hash to find collections.
    #
    def search(search_hash)
      MercadoPago::Collection.search(@access_token, search_hash)
    end

    #
    # Check if mode is sandbox or production
    #
    def sandbox_mode(mode)
      @sandbox = mode
    end
  
    # Private methods.
    #
    private

    #
    # Loads the tokens from the authentication hash.
    #
    # - auth: the authentication hash returned by MercadoPago.
    #
    def load_tokens(auth)
      mandatory_keys = %w{ access_token refresh_token }

      if (auth.keys & mandatory_keys) == mandatory_keys
        @access_token   = auth['access_token']
        @refresh_token  = auth['refresh_token']
      else
        raise AccessError, auth['message']
      end
    end

  end

end
