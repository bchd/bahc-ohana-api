require 'rails_helper'

feature 'report_form_issue' do
  let(:dummy_loc) do
    class DummyLocation
      def name
        "dumy name"
      end
    end

    DummyLocation.new
  end

  context 'for signed in user' do
    setup do
      @user = create(:user)
      login_as @user
    end

    it "should fill up current user email in the form", skip_ci: true do
      allow(Location).to receive(:get).and_return(dummy_loc)
      visit new_flag_path(resource_id: 1, resource_type: 'Location')

      expect(find_field('Email').value).to eq @user.email
    end
  end

  context 'for signed out user' do
    it "should show email field as an empty field", skip_ci: true do
      allow(Location).to receive(:get).and_return(dummy_loc)
      visit new_flag_path(resource_id: 1, resource_type: 'Location')

      expect(find_field('Email').value).to eq nil
    end
  end
end
