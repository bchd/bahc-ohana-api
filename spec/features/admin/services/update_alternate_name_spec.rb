require 'rails_helper'

feature 'Update alternate_name' do
  background do
    loc = create_service.location
    login_super_admin
    visit '/admin/locations/' + loc.slug
    click_link 'Literacy Program'
  end

  scenario 'with valid alternate_name' do
    fill_in 'service_alternate_name', with: 'Youth Counseling'
    click_button I18n.t('admin.buttons.save_changes')
    expect(page).to have_content 'Service was successfully updated.'
    expect(find_field('service_alternate_name').value).to eq 'Youth Counseling'
  end
end
