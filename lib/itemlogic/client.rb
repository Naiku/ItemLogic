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
      @options = {:headers => {'User-Agent' => "Ruby Itemlogic #{VERSION}", 'Accept' => 'application/json', 'Content-Type' => 'application/json'}}
      if token = self.authenticate()
        self.class.default_params['access_token'] = token
      end
    end

    def options(other = {})
      @options.merge(other)
    end

    def authenticate(end_point = nil, data = {})
      if (@api_credentials['client_secret'].blank? || @api_credentials['client_id'].blank?) && @api_credentials['access_token'].blank?
        raise 'Access token or api credentials are required'
      end
      end_point ||= AUTH_ENDPOINT
      headers = {
        'ContentType' => 'application/x-www-form-urlencoded;charset=UTF-8',
        'Accept' => 'application/json',
      }
      data = URI.encode_www_form(data.merge(client_id: @api_credentials['client_id'], client_secret: @api_credentials['client_secret']))
      response = HTTParty.post(self.class.base_uri + end_point, {
        headers: headers,
        body: data
      })

      # if it is not the default one, exit early with that token
      if response.parsed_response && response.parsed_response['body']
        return response.parsed_response['body']['token']
      else
        raise "Could not authenticate against %s: %s -- headers: %s" % [end_point, response.inspect, headers]
      end
    end
  end
end
