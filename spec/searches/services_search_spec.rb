require 'rails_helper'

RSpec.describe ServicesSearch, :elasticsearch do
  def search(attributes = {})
    described_class.new(attributes).search.load
  end

  def import(*args)
    ServicesIndex.import!(*args)
  end

  describe 'archive service search' do
    specify 'only returns services not archived' do
      ServicesIndex.reset!

      location = create(:location)
      service_1 = location.services.create!(name: 'Servive 1', description: "Open", archived: true)
      service_2 = location.services.create!(name: 'Servive 2', description: "Wonderfun", archived: false)
      service_3 = location.services.create!(name: 'Servive 3', description: "jhsjaf", archived: true)
      ServicesIndex.reset!
      
      results = search().objects
      
      expect(results).to contain_exactly(service_2)
      expect(results).not_to include([service_1, service_3])
    end
  end
end