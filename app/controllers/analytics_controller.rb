class AnalyticsController < ApplicationController
  respond_to :json
  def all
    @start_date = DateTime.parse(params[:start_date] || '') rescue DateTime.today - 1.month
    @end_date = DateTime.parse(params[:end_date] || '') rescue DateTime.today

    @total_homepage_views = Ahoy::Visit.where(landing_page: root_url).count
    @new_homepage_views = Ahoy::Visit.
      where(landing_page: root_url).
      where(started_at: @start_date..@end_date).count

    json = {
      total_homepage_views: @total_homepage_views,
      new_homepage_views: @new_homepage_views
    }

    respond_with json
  end
end
