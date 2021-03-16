require 'rails_helper'

describe Category do
  subject { build(:category) }

  it { is_expected.to be_valid }

  it { is_expected.to have_and_belong_to_many(:services) }

  it do
    is_expected.to validate_presence_of(:name).
      with_message("can't be blank for Category")
  end

  it do
    is_expected.to validate_uniqueness_of(:taxonomy_id).
      case_insensitive.with_message('id has already been taken')
  end

  describe ".unarchived" do
    it "dont show category that only has archived services" do
      category_with_archived_service = create(:category)
      category_with_archived_service.services << create(:service, archived_at: DateTime.now)
      expect(Category.unarchived).not_to include(category_with_archived_service)
    end

    it "dont show category that only has services that belong to archived locations" do
      category_with_archived_location = create(:category)
      archived_location = create(:location, archived_at: DateTime.now)
      unarchived_service_with_archived_location = create(:service, location: archived_location)
      category_with_archived_location.services << unarchived_service_with_archived_location
      expect(Category.unarchived).not_to include(category_with_archived_location)
    end

    it "includes categories with unarchived locations with unarchived services associated with the category" do
      good_category = create(:category)
      good_location = create(:location)
      good_service = create(:service, location: good_location)
      good_category.services << good_service
      expect(Category.unarchived).to include(good_category)
    end
  end
end
