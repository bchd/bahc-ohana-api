require 'rails_helper'

feature 'Update description' do
  background do
    @location = create(:location)
    login_super_admin
    visit '/admin/locations/' + @location.slug
  end

  scenario 'with empty description' do
    fill_in 'location_description', with: ''
    click_button I18n.t('admin.buttons.save_changes')
    expect(page).to have_content "Description can't be blank for Location"
  end

  scenario 'with valid description' do
    fill_in 'location_description', with: 'This is a description'
    click_button I18n.t('admin.buttons.save_changes')
    expect(find_field('location_description').value).to eq 'This is a description'
  end
end
