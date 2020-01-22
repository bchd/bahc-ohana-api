class Admin
  class AnalyticsController < ApplicationController
    before_action :authenticate_admin!
    layout 'admin'
    def index
      @organizations_count = Organization.all.count
      @new_org_count = Organization.where('created_at > ?', 30.days.ago).count
      @locations_count = Location.all.count
      @new_location_count = Location.where('created_at > ?', 30.days.ago).count
      @services_count = Service.all.count
      @new_service_count = Service.where('created_at > ?', 30.days.ago).count
    end
  end
end
