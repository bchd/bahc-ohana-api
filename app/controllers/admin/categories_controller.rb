class Admin
  class CategoriesController < ApplicationController
    include ActionView::Helpers::TextHelper
    before_action :authenticate_admin!
    layout 'admin'

    def index
      @categories = Category.unarchived.select{ |c| c.depth == 0 }
    end
  end
end
