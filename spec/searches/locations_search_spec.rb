require 'rails_helper'

RSpec.describe LocationsSearch, :elasticsearch do
  def search(attributes = {})
    described_class.new(attributes).search.load
  end

  def import(*args)
    LocationsIndex.import!(*args)
  end

  describe 'archive location search' do

    before do
      @organization = create(:organization)
      LocationsIndex.delete!
    end

    specify 'only returns locations not archived' do
      location_1 = create_location("covid location", @organization)
      location_2 = create_location("Not featured and not covid", @organization)
      location_3 = create_location("featured location", @organization, "1")

      
      location_1.update_columns(archived_at: Time.zone.yesterday)
      location_2.update_columns(archived_at: nil)
      location_3.update_columns(archived_at: Time.zone.yesterday)
      
      
      import(location_1, location_2, location_3)


      results = search().objects
      expect(results).to contain_exactly(location_2)
      expect(results.size).to eq(1)
      expect(results).not_to include([location_1, location_3])

      location_1.update_columns(archived_at: nil)
      location_2.update_columns(archived_at: Time.zone.yesterday)
      location_3.update_columns(archived_at: nil)

      import(location_1, location_2, location_3)

      # Note can talk to elasticsearch via postman

      results = search().objects
      expect(results).to include(location_1, location_3)
      expect(results.size).to eq(2)
      expect(results).not_to include(location_2)
    end
  end

  describe 'archive location search' do
    before do
      @organization = create(:organization)
      LocationsIndex.delete!
    end


    it 'should return only filtered by accessibility options' do
      location_1 = create_location("covid location", @organization, accessibility: 'ramp')
      location_2 = create_location("Not featured and not covid", @organization, accessibilty: 'ramp')
      location_3 = create_location("featured location", @organization, "1")
      
      import(location_1, location_2, location_3)
      
      results = search({accessibility: 'disabled_parking'}).objects
      expect(results).to include(location_3)
      expect(results.size).to eq(1)
      expect(results).not_to include(location_2, location_1)
      # disabled_parking
    end

  end

end

private

def create_location(name, organization, featured = "0")
  create(:location, name: name, organization: organization, featured: featured)
end