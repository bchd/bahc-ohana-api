class Admin
  class CategoriesController < ApplicationController
    include ActionView::Helpers::TextHelper
    before_action :authenticate_admin!
    layout 'admin'

    def index
      all_categories = Category.all.sort_by(&:name)
      @categories_with_subcategories = assign_children_to_parent_categories(all_categories)
    end

    def edit
      @category = Category.find(params[:id])
      authorize @category
    end

    def update
      @category = Category.find(params[:id])
      authorize @category

      if @category.update(category_params)
        redirect_to admin_categories_path, notice: 'Category was successfully updated.'
      else
        render :edit
      end
    end

    def new
      @category = Category.new
      if params[:ancestry].present?
        @parent_category = Category.find_by(id: params[:ancestry])
      end
      authorize @category
    end

    def create
      @category = Category.new(category_params)
      authorize @category

      if @category.save
        redirect_to admin_categories_path,
                    notice: "Category '#{@category.name}' was successfully created."
      else
        render :new
      end
    end

    private

    def assign_children_to_parent_categories(categories)
      parent_categories = categories.select{ |c| c.depth == 0 }
      categories_with_subcategories = parent_categories.map{ |parent_category| 
        subcategories = categories.select{ |c| c.parent_id == parent_category.id   }
        { parent_category: parent_category, subcategories: subcategories }
      }
    end

    def category_params
      params.require(:category).permit(:name, :ancestry)
    end
  end
end
