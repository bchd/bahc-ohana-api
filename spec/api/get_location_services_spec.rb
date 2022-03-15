require 'rails_helper'

describe 'GET /locations/:location_id/services' do
  context 'when location has services' do
    before :each do
      create_service
      get api_location_services_url(@location)
    end

    it 'returns a 200 status' do
      expect(response).to have_http_status(200)
    end

    it 'serializes all service attributes and associations' do
      expect(json.first.keys).to eq(
        %w[id accepted_payments alternate_name audience description address_details
           eligibility email fees funding_sources application_process
           interpretation_services keywords languages name required_documents
           service_areas status website wait_time updated_at wait_time_updated_at categories
           contacts phones regular_schedules holiday_schedules]
      )
    end
  end

  context "when location doesn't have services" do
    before :each do
      loc = create(:location)
      get api_location_services_url(loc)
    end

    it 'returns an empty array' do
      expect(json).to eq([])
    end

    it 'returns a 200 status' do
      expect(response).to have_http_status(200)
    end
  end
end
