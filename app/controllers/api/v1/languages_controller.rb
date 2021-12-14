module Api
    module V1
      class LanguagesController < ApplicationController
        def index
          languages = Location.active_languages
  
          render json: languages
        end
      end
    end
  end
  