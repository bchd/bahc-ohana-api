class Admin
  class FlagsController < ApplicationController
    before_action :set_flag, only: %i[show edit update destroy]
    layout 'admin'

    # GET /flags
    def index
      @flags = Flag.includes(:resource).all.order("updated_at desc")
    end

    # GET /flags/1
    def show; end

    # GET /flags/new
    def new
      @flag = Flag.new
    end

    # GET /flags/1/edit
    def edit; end

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
      return update_resource(params) if params['flag']['checked'] == 'true' || params['flag']['checked'] == 'false'

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

    def refresh_index
      respond_to do |format|
        format.js {render  notice: 'Flag category was successfully updated.', inline: "location.reload();" }
      end
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

    def update_resource(params)
      @flag.update_attribute(:completed_at, nil) if params['flag']['checked'] == 'true'
      @flag.update_attribute(:completed_at, DateTime.now) if params['flag']['checked'] == 'false'
      refresh_index
    end
  end
end
