class Admin
  class DashboardController < ApplicationController
    layout 'admin'

    def index
      redirect_to new_admin_session_url, allow_other_host: true unless admin_signed_in?
      @orgs = policy_scope(Organization) if current_admin
    end

    def csv_downloads
      redirect_to admin_dashboard_url unless current_admin&.super_admin?
    end
  end
end
