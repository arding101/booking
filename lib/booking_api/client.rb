module BookingApi
  class Client

    def initialize
      @http_service = HttpService.new
    end

    def http_service
      @http_service
    end

    # Implementation of the hotels end point
    def hotels(hotel_ids: [], city_ids: [], country_ids: [], region_ids: [], district_ids: [], chain_ids: [], request_parameters: {})
      if hotel_ids.empty? &&
          city_ids.empty? &&
          country_ids.empty? &&
          region_ids.empty? &&
          district_ids.empty? &&
          chain_ids.empty?
      then
        raise ArgumentError.new('You must supply one of the following parameters: hotel_ids: [], city_ids: [], country_ids: [], region_ids: [], district_ids: [], chain_ids: []')
      end

      default_parameters = {}
      default_parameters[:hotel_ids] = hotel_ids.join(',') if hotel_ids.any?
      default_parameters[:city_ids] = city_ids.join(',') if city_ids.any?
      default_parameters[:country_ids] = country_ids.join(',') if country_ids.any?
      default_parameters[:region_ids] = region_ids.join(',') if region_ids.any?
      default_parameters[:district_ids] = district_ids.join(',') if district_ids.any?
      default_parameters[:chain_ids] = chain_ids.join(',') if chain_ids.any?
      default_parameters[:language] = 'en'
      #request_parameters[:extras] = 'hotel_info'
      http_service.request_get('/json/hotels', default_parameters.merge(request_parameters))
    end

    # Implementation of the cities end point
    def cities(city_ids: [], country_ids: [], request_parameters: {})
      raise ArgumentError if city_ids.empty? && country_ids.empty?
      default_parameters = {}
      default_parameters[:languages] = 'en'
      default_parameters[:city_ids] = city_ids.join(',') if city_ids.any?
      default_parameters[:countries] = country_ids.join(',') if country_ids.any?
      http_service.request_get('/json/cities', default_parameters.merge(request_parameters))
    end

    # Implementation of the changed hotels end point
    def changedHotels(last_change, request_parameters: {})
      raise ArgumentError if last_change.nil?
      default_parameters = {}
      default_parameters[:last_change] = last_change.strftime('%Y-%m-%d %H:%M:%S')
      http_service.request_get('/json/changedHotels', default_parameters.merge(request_parameters))
    end

    private

  end
end