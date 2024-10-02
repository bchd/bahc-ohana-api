class LocationsController < ApplicationController
  include Cacheable

  def index
    # To enable Google Translation of keywords,
    # uncomment lines 9-10 and 18, and see documentation for
    # GOOGLE_TRANSLATE_API_KEY in config/application.example.yml.
    # translator = KeywordTranslator.new(params[:keyword], current_language, 'en')
    # params[:keyword] = translator.translated_keyword
    @main_category_selected_name = ""
    @main_category_selected_id = ""

    unless params[:main_category].nil? || params[:main_category].empty?
      if validate_category
        @main_category_selected_name = params[:main_category]
        @main_category_selected_id = helpers.get_category_id_by_name(@main_category_selected_name)
        params[:main_category_id] = @main_category_selected_id
      end
    end
    if params["categories"] and @main_category_selected_id != ""
      params["categories_ids"] = helpers.get_subcategories_ids(params["categories"], @main_category_selected_id)
    end

    search_params = params.dup

    if !params["main_category"]
      search_params["main_category"] = ""
    end

    @matched_category = match_keyword_to_category(search_params[:keyword])

    if @matched_category
      search_params[:categories] = [@matched_category.id]
      search_params[:main_category] = @matched_category.parent&.name || @matched_category.name
      @main_category_selected_name = search_params[:main_category]
      @main_category_selected_id = @matched_category.parent&.id || @matched_category.id
      search_params[:keyword] = nil
    else
      @main_category_selected_name = ""
      @main_category_selected_id = nil
      search_params[:categories] = []

      if search_params[:keyword].present?
        search_params[:main_category] = ""
        params[:categories] = []
      else
        @main_category_selected_name = search_params[:main_category]
        @main_category_selected_id = helpers.get_category_id_by_name(@main_category_selected_name) if @main_category_selected_name.present?

        if !params["categories"] && !search_params["main_category"].empty?
          if params["main_category_id"].present?
            search_params["categories"] = [params["main_category_id"]]
          end
        elsif params["categories"].present?
          search_params["categories"] = params["categories"]
        end

        if search_params[:categories].present? && @main_category_selected_id
          subcategory_ids = helpers.get_subcategories_ids(search_params[:categories], @main_category_selected_id)
          search_params[:categories] = subcategory_ids.present? ? subcategory_ids : [search_params[:main_category]]
        end
      end
    end

    set_coordinates
    locations = LocationsSearch.new(
      accessibility: search_params[:accessibility],
      category_ids: search_params[:categories],
      distance: search_params[:distance],
      keywords: search_params[:keyword],
      lat: @lat,
      long: @lon,
      org_name: search_params[:org_name],
      tags: search_params[:tags],
      zipcode: search_params[:location],
      page: search_params[:page],
      per_page: search_params[:per_page],
      languages: search_params[:languages],
      matched_category: @matched_category
    ).search.load&.objects


    @search = Search.new(locations, params)
    @keyword = params[:keyword]
    @lat = params[:lat]
    @long = params[:long]
    @address = params[:address]
    @languages = Location.active_languages
    unless params[:languages].nil? || params[:languages].empty?
      @selected_language = params[:languages][0]
    end

    @main_category_selected_name = search_params[:main_category] if @matched_category

    if @address.nil? && @lat.present? && @long.present?
      @address = 'Current Location'
    end

    @selected_distance_filter = params[:distance]

    # Populate the keyword search field with the original term
    # as typed by the user, not the translated word.
    # params[:keyword] = translator.original_keyword
    cache_page(locations) if locations.present?

    respond_to do |format|
      format.html {
        if params[:layout] == "false"
          render :template => 'component/locations/results/_body', :locals => { :search => @search }, :layout => false
        else
          render
        end
      }
    end
  end

  def show
    id = params[:id].split('/').last
    @location = Location.get(id)

    if current_user.present?
      @current_user = current_user
      @current_user_id = current_user.id
      @favorite = current_user.favorites.any? do |f|
        f.resource_id == @location.id && f.resource_type == 'location'
      end
    else
      @favorite = false
      @current_user_id = 0
    end

    # @keywords = @location.services.map { |s| s[:keywords] }.flatten.compact.uniq
    @categories = @location.services.map { |s| s[:categories] }.flatten.compact.uniq

    request.query_parameters["layout"] = true
    @query_parameters = request.query_parameters
    @url = request.url
  end

  # Ajax response to update the exanded div listing subcategories
  def get_subcategories_by_category
    permitted = params.permit(:category_name)
    category_name = permitted["category_name"]

    category_id = helpers.get_category_id_by_name(category_name)
    sub_cat_array = helpers.subcategories_by_category(category_id)

    respond_to do |format|
      format.json { render json: { sub_cat_array: sub_cat_array, category_title: helpers.category_filters_title(category_name) } }
      format.js { render json: { sub_cat_array: sub_cat_array, category_title: helpers.category_filters_title(category_name) } }
    end
  end

  def validate_category
    return helpers.main_categories_array.map{|row| row[0] }.include?(params[:main_category])
  end

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

  def match_keyword_to_category(keyword)
    return nil if keyword.blank?

    Category.where("LOWER(name) = ?", keyword.downcase).first ||
        Category.where("LOWER(name) LIKE ?", "%#{keyword.downcase}%").first
  end

end
