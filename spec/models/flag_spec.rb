require 'rails_helper'

describe Flag, type: :model do
  subject { Flag.new }

  context "validations" do
    it do
      is_expected.to validate_presence_of(:report_attributes).
        with_message("can't be blank")
    end

    it "should validate if all report attributes are blank" do
      subject.report_attributes = {
        hours_location_contact_info_incorrect: "",
        the_service_listed_are_incorrect: "",
        the_eligibility_how_to_access_or_waht_to_bring_is_incorrect: "",
        other: ""
      }

      subject.valid?

      expect(subject.errors[:report_attributes].first).to be_eql("can't be blank")
    end
  end
end
