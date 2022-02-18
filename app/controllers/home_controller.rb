class HomeController < ApplicationController
  include CurrentLanguage

  def index
    @current_lang = current_language
    @recommended_tags = Ohanakapa.recommended_tags
  end
end
