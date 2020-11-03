require 'open-uri'

module Analytics
  def get_ui_analytics
    ui_analytics_api_url = ENV['UI_URL'] + "/api/analytics?start_date=#{@start_date.to_s}&end_date=#{@end_date}"
    
    analytics_json = open(ui_analytics_api_url).read
    JSON.parse(analytics_json)
  end
end
