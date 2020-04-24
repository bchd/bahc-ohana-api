class Admin
  class FlagsController < ApplicationController
    before_action :set_flag, only: [:show, :edit, :update, :destroy]
    layout 'admin'

    # GET /flags
    def index
      @flags = Flag.all
      @orgs = Organization.all
      @flag = Flag.new
    end

    # GET /flags/1
    def show
    end

    # GET /flags/new
    def new
      @flag = Flag.new
    end

    # GET /flags/1/edit
    def edit
    end

    # POST /flags
    def create
      @flag = Flag.new(flag_params)

      if @flag.save
        redirect_to admin_flags_url, notice: 'Flag category was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /flags/1
    def update
      if @flag.update(flag_params)
        redirect_to @flag, notice: 'Flag category was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /flags/1
    def destroy
      @flag.destroy
      redirect_to admin_flags_url, notice: 'Flag category was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_flag
        @flag = Flag.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def flag_params
        params.require(:flag).permit(
          :email,
          :description
        )
      end
  end
end

