
module Api
  module V1
    class FlagsController < ApplicationController
      #include TokenValidator
      include CustomErrors
      protect_from_forgery with: :null_session

      def create
        @flag = Flag.create(JSON.parse(params[:flag]))
        if @flag.save
          render json: @flag
        end
      end

      private
    end
  end
end
