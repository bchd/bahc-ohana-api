class Admin
  class TagsController < ApplicationController
    include Searchable
    before_action :authenticate_admin!
    layout 'admin'

    def index
      tags_all = Tag.all

      @tags = Kaminari.paginate_array(tags_all).
                   page(params[:page]).per(params[:per_page])
    end

    def new
      @tag = Tag.new
    end

    def create
      permitted_params = params.require(:tag).permit(:name)

      @tag = Tag.new(name: permitted_params["name"])
      
      if @tag.save
        redirect_to admin_tags_path,
                    notice: "Tag '#{@tag.name}' was successfully created."
      else
        render :new
      end
    end

    def destroy
      tag = Tag.find(params[:id])
      name = tag.name
      tag.destroy 

      redirect_to admin_tags_path,
                    notice: "Tag '#{tag.name}' was successfully deleted."
    end

    def edit
      @tag = Tag.find(params[:id])
    end

    def update
      @tag = Tag.find(params[:id])
      permitted_params = params.require(:tag).permit(:name)

      if @tag.update(name: permitted_params["name"])
        redirect_to admin_tags_path, notice: 'Tag was successfully updated.'
      else
        render :edit
      end
    end

    def show
      @tag = Tag.find(params[:id])

      resources_all = Tag.get_resources_by_tag_id(@tag.id)
      @resources_array = Kaminari.paginate_array(resources_all).
                   page(params[:page]).per(params[:per_page])
    end
  end

end
