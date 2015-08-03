class Itemlogic
  class Client
    include HTTParty

    VERSION = '0.1'
    attr_accessor :api_credentials, :authenticated, :options

    BASE_URI = 'https://assess.itemlogic.com'
    base_uri BASE_URI
    AUTH_ENDPOINT = '/oauth/token_api'

    # debug_output $stdout

    def initialize(api_credentials, options = {})
      @api_credentials = api_credentials
      if (api_credentials['client_secret'].blank? || api_credentials['client_id'].blank?) && api_credentials['access_token'].blank?
        raise 'Access token or api credentials are required'
      end
      @options = {:headers => {'User-Agent' => "Ruby Itemlogic #{VERSION}", 'Accept' => 'application/json', 'Content-Type' => 'application/json'}}
    end

    def options(other = {})
      if !@authenticated
        authenticate
      end
      @options.merge(other)
    end

    def authenticate(force = false)
      @authenticated = false
      if ! @api_credentials['access_token']
        headers = {
          'ContentType' => 'application/x-www-form-urlencoded;charset=UTF-8',
          'Accept' => 'application/json',
        }
        response = HTTParty.post(self.class.base_uri + AUTH_ENDPOINT, {
          headers: headers,
          body: "client_id=%s&client_secret=%s" % [self.api_credentials['client_id'], self.api_credentials['client_secret']]
        })
        @options[:headers] ||= {}
        if response.parsed_response && response.parsed_response['body']
          self.class.default_params['access_token'] = response.parsed_response['body']['token']
          @authenticated = true
        else
          raise "Could not authenticate: %s -- headers: %s" % [response.inspect, headers]
        end
      end
      return @authenticated
    end
  end
end

