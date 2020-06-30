class Admin
  class ServicesController < ApplicationController
    include Taggable
    include Searchable

    before_action :authenticate_admin!
    layout 'admin'

    def index
      @tags = Tag.all
      @search_terms = search_params(params)

      filtered_services =
        Service.
          updated_between(@search_terms[:start_date], @search_terms[:end_date]).
          with_name(@search_terms[:keyword]).
          with_tag(@search_terms[:tag]).includes(:location).
          page(params[:page]).per(params[:per_page])

      @services = policy_scope(filtered_services)

    end

    def edit
      assign_location_service_and_taxonomy_ids
      @updated = @service.updated_at
      authorize @location
    end

    def update
      assign_location_service_and_taxonomy_ids
      preprocess_service_params
      authorize @location
      preprocess_service
      
      if @service.update(service_params.except(:locations)) && @service.touch(:updated_at)
        redirect_to [:admin, @location, @service],
                    notice: 'Service was successfully updated.'
      else
        render :edit
      end
    end

    def update_capacity
      @service = Service.find(service_capacity_params[:id])
      @service.touch :wait_time_updated_at
      @service.update(service_capacity_params)
      redirect_back(fallback_location: root_path)
    end

    def new
      @location = Location.find(params[:location_id])
      @taxonomy_ids = []

      authorize @location

      @service = Service.new
    end

    def create
      prepare_and_authorize_service_creation

      if @service.save
        redirect_to admin_location_url(@location),
                    notice: "Service '#{@service.name}' was successfully created."
      else
        render :new
      end
    end

    def destroy
      service = Service.find(params[:id])
      authorize service.location
      service.destroy
      redirect_to admin_locations_url
    end

    private

    def prepare_and_authorize_service_creation
      preprocess_service_params

      @location = Location.find(params[:location_id])
      @service = @location.services.new(service_params.except(:locations))
      @taxonomy_ids = []

      authorize @location
      preprocess_service
    end

    def preprocess_service_params
      shift_and_split_params(params[:service], :keywords)
    end

    def preprocess_service
      # add_program_to_service_if_authorized
      add_service_to_location_if_authorized
    end

    def add_program_to_service_if_authorized
      prog_id = service_params[:program_id]
      @service.program = nil and return if prog_id.blank?

      if program_ids_for(@service).select { |id| id == prog_id.to_i }.present?
        @service.program_id = prog_id
      end
    end

    def program_ids_for(service)
      service.location.organization.programs.pluck(:id)
    end

    def add_service_to_location_if_authorized
      return if location_ids.blank?

      location_ids.each do |id|
        Location.find(id.to_i).services.create!(service_params.except(:locations))
      end
    end

    def location_ids
      locations = service_params[:locations]
      return if locations.blank?

      locations.select { |id| location_ids_for(@service).include?(id.to_i) }
    end

    def location_ids_for(service)
      @location_ids_for ||= service.location.organization.locations.pluck(:id)
    end

    def assign_location_service_and_taxonomy_ids
      @service = Service.find(params[:id])
      @location = Location.find(params[:location_id])
      @taxonomy_ids = @service.categories.pluck(:taxonomy_id)
    end

    # rubocop:disable MethodLength
    def service_params
      update_archived_at_params
      params.require(:service).permit(
        { accepted_payments: [] }, :alternate_name, :archived_at, :audience, :description, :eligibility, :email,
        :fees, { funding_sources: [] }, :application_process, :interpretation_services,
        { keywords: [] }, { tag_list: [] }, { languages: [] }, :name, { required_documents: [] },
        { service_areas: [] }, :status, :website, :wait_time, { category_ids: [] },
        :program_id, { locations: [] },
        regular_schedules_attributes: %i[weekday opens_at closes_at id _destroy],
        holiday_schedules_attributes: %i[
          closed start_date end_date opens_at closes_at id _destroy
        ],
        phones_attributes: %i[
          country_prefix department extension number number_type vanity_number id _destroy
        ]
      )
    end
    
    def update_archived_at_params
      if params['service']['archived_at'] == '1'
        params['service']['archived_at'] = Time.zone.now
      elsif params['service']['archived_at'] == '0'
        params['service']['archived_at'] = nil
      end
    end
    # rubocop:enable MethodLength
    
    def service_capacity_params
      params.permit(:wait_time, :id)
    end
  end
end
