# frozen_string_literal: true

module Users
  class RegistrationsController < Devise::RegistrationsController
    prepend_before_action :authenticate_scope!, only: %i[index edit update destroy]
    before_action :configure_sign_up_params, only: %i[create]
    before_action :configure_account_update_params, only: %i[update]

    # GET /users
    def index
      forbidden && return unless current_user&.admin
      @users = User.order(:last_name, :first_name)
    end

    # GET /resource/sign_up
    def new
      @user = User.new
      if current_user&.admin
        super
      else
        render 'new'
      end
    end

    # POST /resource
    # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
    def create
      if params[:user][:password].blank?
        password = SecureRandom.base64(10)
        params[:user][:password] = password
        params[:user][:password_confirmation] = password
      end

      # Copied from devise-4.6.1/app/controllers/devise/registrations_controller.rb
      build_resource(sign_up_params)

      resource.save
      yield resource if block_given?
      if resource.persisted?
        if resource.active_for_authentication?
          set_flash_message! :notice, :signed_up
          # sign_up(resource_name, resource)
          # respond_with resource, location: after_sign_up_path_for(resource)
        else
          set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
          expire_data_after_sign_in!
          # respond_with resource, location: after_inactive_sign_up_path_for(resource)
        end

        resource.send_account_created_instructions
      else
        clean_up_passwords resource
        set_minimum_password_length
        # respond_with resource
      end
      @users = User.order(:last_name, :first_name)
      @user = current_user

      if @user.nil?
        redirect_to :root, notice: "You have been signed up. Please check your email to set a password and complete your registration."
      else
        render :index
      end
    end
    # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

    # GET /resource/edit
    def edit
      if params[:id].present?
        @user = User.find(params[:id])
      else
        super
      end
    end

    # GET /users/edit_user/:id
    def edit_user
      @user = User.find(params[:id])
    end

    # PUT /resource
    # def update
    #   super
    # end

    # PUT /users/update_user/:id
    def update_user
      user = User.find(params[:id])
      user.update! update_user_params(params)
      @users = User.order(:last_name, :first_name)
      @user = current_user
      render :index
    end

    # DELETE /resource
    def destroy
      if params[:id].present?
        user = User.find(params[:id])
        user.destroy
        @users = User.order(:last_name, :first_name)
        render :index
      else
        super
      end
    end

    # GET /resource/cancel
    # Forces the session data which is usually expired after sign
    # in to be expired now. This is useful if the user wants to
    # cancel oauth signing in/up in the middle of the process,
    # removing all OAuth session data.
    # def cancel
    #   super
    # end

    protected

    # Also allow the admin param on sign up.
    def configure_sign_up_params
      devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name last_name organization admin])
    end

    # If you have extra params to permit, append them to the sanitizer.
    def configure_account_update_params
      devise_parameter_sanitizer.permit(:account_update, keys: %i[first_name last_name organization admin])
    end

    def update_user_params(params)
      params.require(:user).permit(:first_name, :last_name, :email, :organization, :admin)
    end

    def not_found
      render file: "#{Rails.root}/public/404.html",  layout: false, status: :not_found
    end

    def forbidden
      render file: "#{Rails.root}/public/403.html",  layout: false, status: :forbidden
    end

    # The path used after sign up.
    # def after_sign_up_path_for(resource)
    #   super(resource)
    # end

    # The path used after sign up for inactive accounts.
    # def after_inactive_sign_up_path_for(resource)
    #   super(resource)
    # end

    def require_no_authentication
      # skip this!
    end
  end
end
