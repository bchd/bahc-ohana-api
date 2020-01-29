require 'open-uri'

module Analytics
  def get_ui_analytics
    ui_analytics_api_url = ENV['UI_URL'] + '/api/analytics'
    analytics_json = open(ui_analytics_api_url).read
    JSON.parse(analytics_json)
  end

  def total_homepage_views(analytics)
    analytics.count do |obj|
      landing_page = obj['landing_page']
      landing_page == ENV['UI_HOMEPAGE_URL']
    end
  end

  def new_homepage_views(analytics, start_date, end_date)
    analytics.count do |obj|
      created_at = Date.parse(obj['started_at'])
      landing_page = obj['landing_page']
      landing_page == ENV['UI_HOMEPAGE_URL'] && created_at.between?(start_date, end_date)
    end
  end
end
