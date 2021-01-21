class Admin
  class TagsController < ApplicationController
    include Searchable

    before_action :authenticate_admin!
    layout 'admin'

    def index
      @tags = Tag.all
    end

    def new
      @tag = Tag.new
    end

    def create
      #prepare_and_authorize_service_creation

      permitted_params = params.require(:tag).permit(:name)
      
      @tag = Tag.new(name: permitted_params["name"])
      
      if @tag.save
        redirect_to admin_tags_path,
                    notice: "Tag '#{@tag.name}' was successfully created."
      else
        render :new
      end
    end

  end
end
