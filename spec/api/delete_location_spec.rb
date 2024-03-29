require 'rails_helper'

describe 'DELETE /locations/:id' do
  before do
    create_service

    LocationsIndex.reset!
    delete api_location_url(@location), {}
  end

  it 'deletes the location' do
    get api_location_url(@location)
    expect(response.status).to eq(404)
    expect(Location.count).to eq(0)
  end

  it 'returns a 204 status' do
    expect(response).to have_http_status(204)
  end

  it 'updates the search index' do
    get api_search_index_url(keyword: 'vrs')
    expect(json.size).to eq(0)
  end
end

describe 'with an invalid token' do
  before do
    create_service
    delete(
      api_location_url(@location),
      {},
      'HTTP_X_API_TOKEN' => 'foo'
    )
  end

  it "doesn't allow deleting a location without a valid token" do
    expect(response.status).to eq(401)
    expect(json['message']).
      to eq('This action requires a valid X-API-Token header.')
  end
end
