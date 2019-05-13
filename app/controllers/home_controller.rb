class HomeController < ApplicationController
  # If the user is signed in, we'd like to greet
  # them on the Home page
  def index
    # TODO: Since we are not (at this time) utilizing the developer
    # portal, we are going to redirect to the admin portal in all cases.
    redirect_to admin_dashboard_url
    @user = current_user
  end
end
