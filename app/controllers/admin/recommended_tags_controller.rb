class Admin
  class RecommendedTagsController < ApplicationController
    before_action :authenticate_admin!
    layout 'admin'

    def index
      @recommended_tags = RecommendedTag.order(:name)
    end

    def show
      @recommended_tag = RecommendedTag.find(params[:id])
      authorize @recommended_tag
    end

    def new
      @recommended_tag = RecommendedTag.new
      authorize @recommended_tag
    end

    def create
      @recommended_tag = RecommendedTag.new(permitted_params)
      authorize @recommended_tag

      if @recommended_tag.save
        redirect_to admin_recommended_tags_path,
                    notice: "Recommended Tag '#{@recommended_tag.name}' was successfully created."
      else
        render :new
      end
    end

    def edit
      @recommended_tag = RecommendedTag.find(params[:id])
      authorize @recommended_tag
    end

    def update
      @recommended_tag = RecommendedTag.find(params[:id])
      authorize @recommended_tag

      if @recommended_tag.update(permitted_params)
        redirect_to admin_recommended_tags_path, notice: 'Recommended Tag was successfully updated.'
      else
        render :edit
      end
    end

    def destroy
      @recommended_tag = RecommendedTag.find(params[:id])
      authorize @recommended_tag

      name = @recommended_tag.name
      @recommended_tag.destroy

      redirect_to admin_recommended_tags_path,
                    notice: "Recommended Tag '#{name}' was successfully deleted."
    end

    private

    def permitted_params
      params.require(:recommended_tag).permit([:name, :active, tag_list: []])
    end
  end
end
