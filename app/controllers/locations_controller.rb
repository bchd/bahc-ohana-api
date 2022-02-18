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
    locations = Location.search(params).compact
    @search = Search.new(locations, Ohanakapa.last_response, params)
    @keyword = params[:keyword]
    @lat = params[:lat]
    @long = params[:long]
    @address = params[:address]
    @languages = Ohanakapa.languages
    unless params[:languages].nil? || params[:languages].empty?
      @selected_language = params[:languages][0]
    end  

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
  end

  # Ajax response to update the exanded div listing subcategories
  def get_subcategories_by_category
    permitted = params.permit(:category_name)
    category_name = permitted["category_name"]

    sub_cat_array = []
    category_id = helpers.get_category_id_by_name(category_name)
    sub_cat_array = helpers.subcategories_by_category(category_id)

    respond_to do |format|
      format.js { render :json => {sub_cat_array: sub_cat_array, category_title: helpers.category_filters_title(category_name)}.to_json }
    end
  end

  def validate_category
    return helpers.main_categories_array.map{|row| row[0] }.include?(params[:main_category])
  end

end
