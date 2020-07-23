class Admin
  class ManagementController < ApplicationController
    layout 'admin'
    before_action :authorize_admin
    before_action :find_admin, only: %i[edit update]

    # rubocop:disable Metrics/AbcSize
    def drop_admin
      location = Location.find drop_admin_params[:location][:id]
      admin = Admin.find drop_admin_params[:location][:admin_id]
      location.admin_emails.delete admin.email
      location.save
      redirect_to request.referer,
                    notice: "Successfully removed admin from location."
    end
    # rubocop:enable Metrics/AbcSize

    private

    def authorize_admin
      unless admin_signed_in?
        flash[:error] = t('devise.failure.unauthenticated')
        return redirect_to new_admin_session_url
      end
      user_not_authorized unless current_admin.super_admin?
    end

    def drop_admin_params
      params.permit(location: %i[id admin_id])
    end

    def find_admin
      @admin = Admin.find params[:id]
    end
  end
end
