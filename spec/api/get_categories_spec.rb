require 'rails_helper'
require 'pry'

describe 'GET /categories' do
  before do
    @food = Category.create!(name: 'Food', taxonomy_id: '101')
    @emergency = Category.create!(name: 'Emergency', taxonomy_id: '103')
    @location = create(:location)
    @food.services << create(:service, location: @location)
    @emergency.services << create(:service, location: @location)
    get api_categories_url
  end

  it 'displays both categories' do
    expect(json.size).to eq(2)
  end

  it 'returns a 200 status' do
    expect(response).to have_http_status(200)
  end

  it 'includes the id attribute in the serialization' do
    expect(json.first['id']).to eq(@emergency.id)
  end

  it 'includes the depth attribute in the serialization' do
    expect(json.first['depth']).to eq(@emergency.depth)
  end

  it 'includes the taxonomy_id attribute in the serialization' do
    expect(json.first['taxonomy_id']).to eq(@emergency.taxonomy_id)
  end

  it 'includes the name attribute in the serialization' do
    expect(json.first['name']).to eq(@emergency.name)
  end

  it 'includes the parent_id attribute in the serialization' do
    expect(json.first['parent_id']).to eq(@emergency.parent_id)
  end
end
