require 'rails_helper'

feature 'Update email' do
  background do
    @location = create_service.location
    login_super_admin
    visit '/admin/locations/' + @location.slug
    click_link 'Literacy Program'
  end

  scenario 'with invalid email' do
    fill_in 'service_email', with: 'foobar.com'
    click_button I18n.t('admin.buttons.save_changes')
    expect(page).to have_content 'is not a valid email'
  end

  scenario 'with valid email' do
    fill_in 'service_email', with: 'ruby@good.com'
    click_button I18n.t('admin.buttons.save_changes')
    expect(page).to have_content 'Service was successfully updated.'
    expect(find_field('service_email').value).to eq 'ruby@good.com'
  end
end
