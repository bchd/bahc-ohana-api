module Api
  module V1
    class CategoriesController < ApplicationController
      def index
        categories = Category.all.select{|cat| cat.services.any?{|service| !service.archived?}}
        render json: categories, status: :ok
      end

      def children
        children = Category.find_by(taxonomy_id: params[:taxonomy_id]).children
        render json: children, status: :ok
      end
    end
  end
end
