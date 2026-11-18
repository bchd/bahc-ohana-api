require 'rails_helper'

RSpec.describe TagResource, type: :model do
  it { is_expected.to belong_to(:tag) }
  it { is_expected.to belong_to(:resource) }

  describe '.get_resources' do
    it 'returns the resources attached to the given tag' do
      tag = Tag.create!(name: 'housing')
      service = create(:service)
      TagResource.create!(tag: tag, resource: service)

      result = TagResource.get_resources(tag.id)

      expect(result.map { |tr| [tr.resource_id, tr.resource_type] }).
        to eq [[service.id, 'Service']]
    end
  end
end
