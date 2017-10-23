module BookingApi
  class HttpService

    ENDPOINT = 'https://distribution-xml.booking.com/2.0'

    def initialize
      @auth_username = BookingApi.username
      @auth_password = BookingApi.password
    end

    def connection
      @connection ||= begin
        Faraday.new(:url => 'https://distribution-xml.booking.com/2.0') do |faraday|
          faraday.basic_auth @auth_username, @auth_password
          faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
          faraday.response :json, :content_type => /\bjson$/
        end
      end
    end

    def request_post(url, data, request_options = {})
      connection.post do |req|
        req.url ENDPOINT + url
        req.headers['Content-Type'] = 'application/json'
        req.body = data.to_json
        req.options.timeout = request_options[:timeout] if request_options[:timeout]
      end
    end

    def request_get(url, data, request_options = {})
      connection.get do |req|
        req.url ENDPOINT + url
        req.headers['Content-Type'] = 'application/json'
        req.body = data.to_json
        req.options.timeout = request_options[:timeout] if request_options[:timeout]
      end
    end

  end
end
