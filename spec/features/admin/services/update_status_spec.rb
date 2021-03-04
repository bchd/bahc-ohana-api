require 'rails_helper'

feature 'Update status' do
  background do
    @location = create_service.location
    login_super_admin
    visit '/admin/locations/' + @location.slug
  end

  scenario 'with valid status' do
    click_link 'Literacy Program'
    select 'Defunct', from: 'service_status'
    click_button I18n.t('admin.buttons.save_changes')
    expect(page).to have_content 'Service was successfully updated.'
    expect(find_field('service_status').value).to eq 'defunct'
  end
end
