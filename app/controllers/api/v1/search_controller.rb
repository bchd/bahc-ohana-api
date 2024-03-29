module Api
  module V1
    class SearchController < ApplicationController
      include PaginationHeaders
      include CustomErrors
      include Cacheable

      after_action :set_cache_control, only: :index

      def index
        set_coordinates

        locations = LocationsSearch.new(
          accessibility: params[:accessibility],
          category_ids: params[:categories],
          distance: params[:distance],
          keywords: params[:keyword],
          lat: @lat,
          long: @lon,
          org_name: params[:org_name],
          tags: params[:tags],
          zipcode: params[:location],
          page: params[:page],
          per_page: params[:per_page],
          languages: params[:languages]
        ).search.load&.objects
        
        generate_pagination_headers(locations)

        locations = locations.compact

        render json: locations, each_serializer: LocationsSerializer, status: :ok
      end

      def search_needs
        locations = Location.search_needs_location(params).page(params[:page]).
                    per(params[:per_page])

        return unless stale?(etag: cache_key(locations), public: true)

        generate_pagination_headers(locations)
        render json: locations.preload(tables), each_serializer: LocationsSerializer, status: :ok
      end

      def nearby
        location = Location.find(params[:location_id])

        render json: [] and return if location.latitude.blank?

        render json: locations_near(location), each_serializer: NearbySerializer, status: :ok
        generate_pagination_headers(locations_near(location))
      end

      # Allows lookahead search on the name of various objects in the database.
      #
      #   GET /api/lookahead?name=center&klass=organization
      #
      # This will search for Organizations with 'center' somewhere in their name.
      #
      # +klass+ can be the name of any object that has name as an attribute, e.g.,
      #
      #   * organization
      #   * location
      #   * service
      #   * program (unused)
      #   * category
      #
      # If not given, klass is assumed to be 'Location'
      #
      # Return is a JSON array of arrays, with +[name, id]+ for each matching object.
      #
      # rubocop:disable Style/ConditionalAssignment, Style/RescueStandardError
      def lookahead
        klass = lookahead_klass
        if lookahead_params[:name].length > 2
          matches = lookahead_search klass, lookahead_params[:name]
        else
          matches = klass.none
        end

        render json: matches.map { |loc| [loc.name, loc.id] }
      rescue
        render json: []
      end
      # rubocop:enable Style/ConditionalAssignment, Style/RescueStandardError

      private

      def set_coordinates
        address = params[:address]
        if address.present? && address != "Current Location"
          response = Geocoder.search(params[:address])
          unless response.empty?
            coordinates = response.first.data['geometry']['location']
            @lat = coordinates['lat']
            @lon = coordinates['lng']
          end  
        elsif params[:lat].present? && params[:long]
          @lat = params[:lat]
          @lon = params[:long]
        end
      end

      def address_params
        if params[:address].present?
          response = Geocoder.search(params[:address])
          coordinates = response.first.data['geometry']['location']
          full_address = response.first.data['formatted_address']
        end
      end

      def lookahead_params
        params.permit(:name)
      end

      def lookahead_search(klass, name)
        klass.where(
          'LOWER(name) LIKE ?',
          "%#{name.downcase}%"
        )
      end

      def lookahead_klass
        return nil if params[:klass]&.downcase == 'user'
        klass = params[:klass]&.camelize&.constantize
        klass || Location
      end

      def tables
        %i[organization address phones]
      end

      def locations_near(location)
        location.nearbys(params[:radius]).status('active').
          page(params[:page]).per(params[:per_page]).includes(:address)
      end

      def cache_key(scope)
        Digest::MD5.hexdigest(
          "#{scope.to_sql}-#{scope.maximum(:updated_at)}-#{scope.total_count}"
        )
      end
    end
  end
end
