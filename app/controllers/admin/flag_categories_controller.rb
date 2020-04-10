class Admin
  class FlagCategoriesController < ApplicationController
    before_action :set_flag_category, only: [:show, :edit, :update, :destroy]
    layout 'admin'

    # GET /flag_categories
    def index
      @flag_categories = FlagCategory.all
      @flag_category = FlagCategory.new
    end

    # GET /flag_categories/1
    def show
    end

    # GET /flag_categories/new
    def new
      @flag_category = FlagCategory.new
    end

    # GET /flag_categories/1/edit
    def edit
    end

    # POST /flag_categories
    def create
      @flag_category = FlagCategory.new(flag_category_params)

      if @flag_category.save
        redirect_to admin_flag_categories_url, notice: 'Flag category was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /flag_categories/1
    def update
      if @flag_category.update(flag_category_params)
        redirect_to @flag_category, notice: 'Flag category was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /flag_categories/1
    def destroy
      @flag_category.destroy
      redirect_to admin_flag_categories_url, notice: 'Flag category was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_flag_category
        @flag_category = FlagCategory.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def flag_category_params
        params.require(:flag_category).permit(
          :name
        )
      end
  end
end
