class Admin
  class CsvController < ApplicationController
    before_action :authorize_admin
    # The CSV content for each action is defined in
    # app/views/admin/csv/{action_name}.csv.shaper

    def addresses; end

    def categories; end

    def contacts; end

    def covid_19_locations; end

    def food_and_covid_services; end

    def holiday_schedules; end

    def locations; end

    def organizations; end

    def phones; end

    def programs; end

    def regular_schedules; end

    def services; end
    
    def service_categories; end

    def upload_service_categories
      unless upload_service_categories_params.present?
        flash[:error] = t('admin.services.upload.missing')
        redirect_to admin_csv_downloads_path and return
      end

      importer = ServiceCategoriesUploader.new(params['service-categories'].tempfile)
      importer.process('admin')
      flash[:notice] = t('admin.services.upload.success')
      redirect_to admin_csv_downloads_path

    rescue ServiceCategoriesUploader::ServiceCategoriesUploadError => error
      flash[:error] = error.message
      redirect_to admin_csv_downloads_path
    end

    def upload_services
      upload_services_params
      unless params[:services].present?
        flash[:error] = t('admin.services.upload.missing')
        redirect_to admin_csv_downloads_path and return
      end
      importer = ServiceUploader.new(params[:services].tempfile)
      importer.process
      flash[:notice] = t('admin.services.upload.success')
      redirect_to admin_csv_downloads_path
    rescue ServiceUploader::ServiceUploadError => e
      flash[:error] = e.message
      redirect_to admin_csv_downloads_path
    end

    private

    def authorize_admin
      unless admin_signed_in?
        flash[:error] = t('devise.failure.unauthenticated')
        return redirect_to new_admin_session_url, allow_other_host: true
      end
      user_not_authorized unless current_admin.super_admin?
    end

    def upload_services_params
      params.permit(:services)
    end

    def upload_service_categories_params
      params.permit('service-categories')
    end
  end
end
