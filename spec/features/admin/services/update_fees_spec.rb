require 'rails_helper'

feature 'Update fees' do
  background do
    @location = create_service.location
    login_super_admin
    visit '/admin/locations/' + @location.slug
  end

  scenario 'with valid fees' do
    click_link 'Literacy Program'
    fill_in 'service_fees', with: 'Youth Counseling'
    click_button I18n.t('admin.buttons.save_changes')
    expect(page).to have_content 'Service was successfully updated.'
    expect(find_field('service_fees').value).to eq 'Youth Counseling'
  end
end
