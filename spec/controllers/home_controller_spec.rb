require 'rails_helper'

# TODO: currently redirecting to /admin
describe HomeController do
  describe "GET 'index'" do
    it 'returns http success' do
      get 'index'
      # expect(response).to be_success
      expect(response).to have_http_status(302)
    end
  end
end
