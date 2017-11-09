module BookingApi
  class HttpService

    ENDPOINT = 'https://distribution-xml.booking.com'

    def initialize
      @auth_username = BookingApi.username
      @auth_password = BookingApi.password
    end

    def connection
      @connection ||= begin
        Faraday.new(:url => ENDPOINT) do |faraday|
          faraday.basic_auth @auth_username, @auth_password
          faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
          faraday.response :logger
          faraday.response :json, :content_type => /\bjson$/
        end
      end
    end

    # Post request
    def request_post(url, data, request_options = {})
      request('post', url, data, request_options)
    end

    # Get request
    def request_get(url, data, request_options = {})
      request('get', url, data, request_options)
    end

    # Process generic request
    def request(method, url, data, request_options)
      url = '/2.0' + url
      content_type = 'application/json'
      body = data.to_json

      case method
        when 'get'
          connection.get do |req|
            req.url url
            req.headers['Content-Type'] = content_type
            req.body = body
            req.options.timeout = request_options[:timeout] if request_options[:timeout]
          end
        when 'post'
          connection.post do |req|
            req.url url
            req.headers['Content-Type'] = content_type
            req.body = body
            req.options.timeout = request_options[:timeout] if request_options[:timeout]
          end
      end
    end

  end
end
