require 'rails_helper'

RSpec.describe LocationsSearch, :elasticsearch do
  def search(attributes = {})
    described_class.new(attributes).search.load
  end

  def import(*args)
    LocationsIndex.import!(*args)
  end

  describe 'by organization name' do 
    before do
      @org1 = create(:organization, name: 'Partial Match on Org Name DRUG COMPANY')
      @org2 = create(:organization, name: 'Not At All a Match Group')
      LocationsIndex.reset!
    end

    specify 'partial match on org name tops partial match on location name or service name' do
      location_1 = create_location("org name partial match", @org1)
      location_2 = create_location("location name partial match DRUG COMPANY", @org2)
      location_3 = create_location("Service name partial match", @org2)

      service = create(:service, location: location_3, name: "Service with matching terms on category name")
      create(:category, services: [service], name: "Catgory for DRUG COMPANY supplies")

      import(location_1, location_2, location_3)

      results = search({keywords: 'DRUG COMPANY'}).objects

      expect(results.first.id).to be(location_1.id)
      expect(results.second.id).to be(location_2.id)
      expect(results.third.id).to be(location_3.id)
    end
  end

  describe 'by location name' do
    before do
      @organization = create(:organization)
      LocationsIndex.reset!
    end

    specify 'exact matches on location names are included in results' do
      location_1 = create_location("NOT EVEN CLOSE", @organization)
      location_2 = create_location("EXACT MATCH OF NAME", @organization)

      import(location_1, location_2)

      results = search({keywords: 'EXACT MATCH OF NAME'}).objects

      expect(results).to include(location_2)
      expect(results).not_to include(location_1)
    end

    specify 'exact matches are prioritized over partial matches' do
      location_1 = create_location("DEAD ON EXACT MATCH BUDDY", @organization)
      location_2 = create_location("PARTIAL MATCH ON BUDDY", @organization)

      import(location_1, location_2)
      
      results = search({keywords: 'DEAD ON EXACT MATCH BUDDY'})

      expect(results[0].id).to be(location_1.id)
      expect(results[1].id).to be(location_2.id)
    end
  end

  describe 'by location description' do
    before do
      @organization = create(:organization)
      LocationsIndex.reset!
    end

    specify 'location description contains "Salvation" OR "Army"' do
      location_1 = create_location("NOT EVEN CLOSE", @organization)
      location_2 = create_location("DESCRIPTION CONTAINS THE FIRST TERM", @organization)
      location_3 = create_location("DESCRIPTION CONTAINS THE SECOND TERM", @organization)

      location_1.update_columns(description: "This is a description that has no relationship or reference to the terms in the search query.")
      location_2.update_columns(description: "This is a description that contains the word Salvation. So it should show up in the results.")
      location_3.update_columns(description: "This is a description that contains the word Army. So it should show up in the results.")

      import(location_1, location_2, location_3)

      results = search({keywords: 'Salvation Army'}).objects

      expect(results).to include(location_3)
      expect(results).to include(location_2)
      expect(results).not_to include(location_1)
    end

    specify 'location description contains "Salvation" AND "Army"' do
      location_1 = create_location("NOT EVEN CLOSE", @organization)
      location_2 = create_location("EXACT MATCH OF NAME", @organization)

      location_1.update_columns(description: "This is a description that has no relationship or reference to the terms in the search query.")
      location_2.update_columns(description: "This is a description that contains the word Salvation AND also it contains the world Army. So it should show up in the results.")

      import(location_1, location_2)

      results = search({keywords: 'Salvation Army'}).objects

      expect(results).to include(location_2)
      expect(results).not_to include(location_1)
    end
  end

  describe 'terms matching across two fields' do
    before do
      @organization = create(:organization)
      LocationsIndex.reset!
    end

    specify 'location description contains "Salvation" AND service description contains "Army"' do
      location_1 = create_location("NOT EVEN CLOSE", @organization)
      location_2 = create_location("EXACT MATCH IN TWO FIELDS", @organization)

      location_1.update_columns(description: "This is a description that has no relationship or reference to the terms in the search query.")
      location_2.update_columns(description: "This is a description that contains the word Salvation")
      service = create(:service, location: location_2, description: "This one has the word Army in it.")

      import(location_1, location_2)

      results = search({keywords: 'Salvation Army'}).objects

      expect(results).to include(location_2)
      expect(results).not_to include(location_1)
    end
  end

  describe 'by service name' do
    before do
      @organization = create(:organization)
      LocationsIndex.reset!
    end

    specify 'matches on location that has service name with TERM1 OR TERM2' do
      location_1 = create_location("service name don't match", @organization)
      location_2 = create_location("Has service with the first term", @organization)
      location_3 = create_location("Has service with the second term", @organization)

      service_1 = create(:service, location: location_1, name: "Service name with neither term")
      service_2 = create(:service, location: location_2, name: "Term1 but not the second")
      service_3 = create(:service, location: location_3, name: "Term2 but not the first")

      import(location_1, location_2, location_3)

      results = search({keywords: 'Term1 Term2'}).objects

      expect(results).to include(location_3)
      expect(results).to include(location_2)
      expect(results).not_to include(location_1)
    end

    specify 'matches on location that has service name with TERM1 AND TERM2' do
      location_1 = create_location("service name don't match", @organization)
      location_2 = create_location("Has service with both terms", @organization)

      service_1 = create(:service, location: location_1, name: "Service name with neither term")
      service_2 = create(:service, location: location_2, name: "Term1 but also Term2")

      import(location_1, location_2)

      results = search({keywords: 'Term1 Term2'}).objects

      expect(results).to include(location_2)
      expect(results).not_to include(location_1)
    end
  end

  describe 'by service description' do
    before do
      @organization = create(:organization)
      LocationsIndex.reset!
    end

    specify 'matches on location that has service description with TERM1 OR TERM2' do
      location_1 = create_location("service description don't match", @organization)
      location_2 = create_location("Has service description with first term", @organization)
      location_3 = create_location("Has service description with second term", @organization)

      service_1 = create(:service, location: location_1, description: "Service name with neither term")
      service_2 = create(:service, location: location_2, description: "Term1 but not 2")
      service_3 = create(:service, location: location_3, description: "Term2 but not 1")

      import(location_1, location_2, location_3)

      results = search({keywords: 'Term1 Term2'}).objects

      expect(results).to include(location_3)
      expect(results).to include(location_2)
      expect(results).not_to include(location_1)
    end
    specify 'matches on location that has service description with TERM1 AND TERM2' do
      location_1 = create_location("service description don't match", @organization)
      location_2 = create_location("Has service description with both terms", @organization)

      service_1 = create(:service, location: location_1, description: "Service name with neither term")
      service_2 = create(:service, location: location_2, description: "Term1 but also Term 2")

      import(location_1, location_2)

      results = search({keywords: 'Term1 Term2'}).objects

      expect(results).to include(location_2)
      expect(results).not_to include(location_1)
    end
  end
  
  describe 'by service category' do
    before do
      @organization = create(:organization)
      LocationsIndex.reset!
    end

    specify 'exact matches on service categories are included in results' do
      location_1 = create_location("service categories don't match", @organization)
      location_2 = create_location("service categories contain a partial match", @organization)

      service_1 = create(:service, location: location_1)
      service_2 = create(:service, location: location_2)

      create(:category, services: [service_2], name: "QWERTY UIOP")

      import(location_1, location_2)

      results = search({keywords: 'QWERTY UIOP'}).objects

      expect(results).to include(location_2)
      expect(results).not_to include(location_1)
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

  describe 'location search' do
    before do
      @organization = create(:organization)
      LocationsIndex.reset!
    end
  
    it 'should return same results searching with and without stoping words' do
      location_1 = create_location("Animal Shelter", @organization)
      location_2 = create_location("Food and Shelter", @organization)
      location_3 = create_location("This is a Featured location", @organization)
  
      import(location_1, location_2, location_3)
  
      results_no_stop_words = search({keywords: 'Animal Shelter'}).objects
      expect(results_no_stop_words).to include(location_1)
      expect(results_no_stop_words).to include(location_2)
      expect(results_no_stop_words.size).to eq(2)
  
      results_with_stop_words = search({keywords: 'the Animal Shelter is an a'}).objects
      expect(results_with_stop_words).to include(location_1)
      expect(results_with_stop_words).to include(location_2)
      expect(results_with_stop_words.size).to eq(2)
    end
  end

  describe 'location search matching tags' do
    before do
      @organization = create(:organization)
      LocationsIndex.reset!
    end
  
    it 'should return locations matching the location - tags' do
      #tag name (Education) taken from tags factory
      location_1 = create(:location_with_tag)
      location_2 = create_location("Location with no tag", @organization)
      import(location_1, location_2)
  
      results = search({keywords: 'Education'}).objects
      expect(results).to include(location_1)
      expect(results.size).to eq(1)

    end

    it 'should return locations matching the locations organization - tags' do
      organization_with_tag = create(:organization_with_tag)
      location_1 = create_location("Location with tagged organization", organization_with_tag)
      location_2 = create_location("Location with no tagged organization", @organization)
      import(location_1, location_2)
  
      results = search({keywords: 'Organization_tag'}).objects
      expect(results).to include(location_1)
      expect(results.size).to eq(1)
    end

    it 'should return locations matching the locations services - tags' do
      location_1 = create(:location, organization: @organization)
      service = create(:service, location: location_1)
      service.tags << create(:tag_service)
      location_2 = create_location("Location with no tagged services", @organization)

      import(location_1, location_2)
      results = search({keywords: 'Service_tag'}).objects
      expect(results).to include(location_1)
      expect(results.size).to eq(1)
    end

  end
end

private

def create_location(name, organization, featured = "0")
  create(:location, name: name, organization: organization, featured: featured)
end
