
module Api
  module V1
    class FlagsController < ApplicationController
      # include TokenValidator
      include CustomErrors
      protect_from_forgery with: :null_session

      def create
        @flag = Flag.create(JSON.parse(params[:flag]))
        render json: @flag if @flag.save
      end

      private
    end
  end
end
