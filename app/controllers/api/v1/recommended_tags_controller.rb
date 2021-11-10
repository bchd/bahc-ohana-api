module Api
  module V1
    class RecommendedTagsController < ApplicationController
      def index
        recommended_tags = RecommendedTag.active

        render json: recommended_tags
      end
    end
  end
end
