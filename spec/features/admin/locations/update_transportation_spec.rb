require 'rails_helper'

feature 'Update transportation options' do
  background do
    @location = create(:location)
    login_super_admin
    visit '/admin/locations/' + @location.slug
  end

  scenario 'with empty transportation options' do
    fill_in 'location_transportation', with: ''
    click_button I18n.t('admin.buttons.save_changes')
    expect(find_field('location_transportation').value).to eq ''
  end

  scenario 'with non-empty transportation options' do
    fill_in 'location_transportation', with: 'SAMTRANS stops within 1/2 mile.'
    click_button I18n.t('admin.buttons.save_changes')
    expect(find_field('location_transportation').value).
      to eq 'SAMTRANS stops within 1/2 mile.'
  end
end
