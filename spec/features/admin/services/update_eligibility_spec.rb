require 'rails_helper'

feature 'Update eligibility' do
  background do
    @location = create_service.location
    login_super_admin
    visit '/admin/locations/' + @location.slug
  end

  scenario 'with valid eligibility' do
    click_link 'Literacy Program'
    fill_in 'service_eligibility', with: 'Youth Counseling'
    click_button I18n.t('admin.buttons.save_changes')
    expect(page).to have_content 'Service was successfully updated.'
    expect(find_field('service_eligibility').value).to eq 'Youth Counseling'
  end
end
