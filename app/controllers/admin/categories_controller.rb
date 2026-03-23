class Admin
  class CategoriesController < ApplicationController
    include ActionView::Helpers::TextHelper
    before_action :authenticate_admin!
    layout 'admin'

    def index
      @categories = Category.all.select{ |c| c.depth == 0 }.sort_by(&:name)
    end
  end
end
