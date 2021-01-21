class Admin
  class TagsController < ApplicationController
    include Searchable

    before_action :authenticate_admin!
    layout 'admin'

    def index
      @tags = Tag.all
    end

  end
end
