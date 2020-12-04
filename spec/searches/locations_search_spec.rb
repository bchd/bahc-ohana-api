require 'rails_helper'

RSpec.describe LocationsSearch, :elasticsearch do
  def search(attributes = {})
    described_class.new(attributes).search.load
  end

  def import(*args)
    LocationsIndex.import!(*args)
  end

  describe 'by service category' do
    before do
      @organization = create(:organization)
      LocationsIndex.reset!
    end

    specify 'partial matches on service categories are included in results' do
      location_1 = create_location("service categories don't match", @organization)
      location_2 = create_location("service categories contain a partial match", @organization)

      service_1 = create(:service, location: location_1)
      service_2 = create(:service, location: location_2)

      create(:category, services: [service_2], name: "QWERTY UIOP")

      import(location_1, location_2)

      results = search({keywords: 'QWERTY'}).objects

      expect(results).to include(location_2)
      expect(results).not_to include(location_1)
    end
  end

  describe 'archive location search' do
    before do
      @organization = create(:organization)
      LocationsIndex.reset!
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

      results = search().objects
      expect(results).to include(location_1, location_3)
      expect(results.size).to eq(2)
      expect(results).not_to include(location_2)
    end
  end

  describe 'archive location search' do
    before do
      @organization = create(:organization)
      LocationsIndex.reset!
    end


    it 'should return only filtered by accessibility options' do
      location_1 = create_location("covid location", @organization, accessibility: 'ramp')
      location_2 = create_location("Not featured and not covid", @organization, accessibilty: 'ramp')
      location_3 = create_location("featured location", @organization, "1")
      location_1.update_columns(accessibility: ['ramp'])

      import(location_1, location_2, location_3)

      results = search({accessibility: 'ramp'}).objects
      expect(results).to include(location_1)
      expect(results.size).to eq(1)
      expect(results).not_to include(location_2, location_3)

      location_1.update_columns(accessibility: ['disabled_parking'])
      location_2.update_columns(accessibility: ['ramp'])
      location_3.update_columns(accessibility: ['ramp'])

      import(location_1, location_2, location_3)

      results = search({accessibility: 'disabled_parking'}).objects
      expect(results).to include(location_1)
      expect(results.size).to eq(1)
      expect(results).not_to include(location_2, location_3)
    end
  end
end

private

def create_location(name, organization, featured = "0")
  create(:location, name: name, organization: organization, featured: featured)
end
