require 'rails_helper'

feature 'Delete service' do
  background do
    @location = create_service.location
    login_super_admin
    visit '/admin/locations/' + @location.slug
  end

  scenario 'when submitting warning', :js do
    click_link 'Literacy Program'
    find_link(I18n.t('admin.buttons.delete_service')).click
    find_link(I18n.t('admin.buttons.confirm_delete_service')).click
    expect(page).to have_content('Service was successfully removed.')
    click_link 'VRS Services'
    expect(page).not_to have_link 'Literacy Program'
  end

  scenario 'when canceling warning', :js do
    click_link 'Literacy Program'
    find_link(I18n.t('admin.buttons.delete_service')).click
    find_button('Close').click
    visit '/admin/locations/' + @location.slug
    expect(page).to have_link 'Literacy Program'
  end
end
