require 'rails_helper'

feature 'Update wait_time' do
  background do
    create_service
    login_super_admin
    visit '/admin/locations/vrs-services'
  end

  scenario 'with valid wait_time' do
    click_link 'Literacy Program'
    select "Available Today", from: "service_wait_time"
    click_button I18n.t('admin.buttons.save_changes')
    expect(page).to have_content 'Service was successfully updated.'
    expect(find_field('service_wait_time').value).to eq 'Available Today'
  end
end
