class HomeController < ApplicationController
  include CurrentLanguage

  def index
    @current_lang = current_language
    @recommended_tags = RecommendedTag.active
  end
end
