class Admin
  class TagsController < ApplicationController
    include Searchable
    before_action :authenticate_admin!
    layout 'admin'

    def index
      @search_terms = search_params(params)

      if @search_terms.empty?
        tags_all = Tag.all
      else
        tags_all = Tag.with_name_or_id(@search_terms[:keyword])
      end
      @tags = Kaminari.paginate_array(tags_all).
                   page(params[:page]).per(params[:per_page])
    end

    def new
      @tag = Tag.new
    end

    def create
      permitted_params = params.require(:tag).permit(:name)

      @tag = Tag.new(name: permitted_params["name"])
      authorize @tag
      
      if @tag.save
        redirect_to admin_tags_path,
                    notice: "Tag '#{@tag.name}' was successfully created."
      else
        render :new
      end
    end

    def destroy
      @tag = Tag.find(params[:id])
      authorize @tag
      name = @tag.name
      @tag.destroy 

      redirect_to admin_tags_path,
                    notice: "Tag '#{name}' was successfully deleted."
    end

    def edit
      @tag = Tag.find(params[:id])
      authorize @tag
    end

    def update
      @tag = Tag.find(params[:id])
      authorize @tag
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
