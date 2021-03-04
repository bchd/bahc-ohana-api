require 'rails_helper'

feature 'Delete contact' do
  background do
    @location = create_service.location
    @service.contacts.create!(attributes_for(:contact))
    login_super_admin
    visit '/admin/locations/' + @location.slug
    click_link 'Literacy Program'
    click_link 'Moncef Belyamani'
  end

  scenario 'when deleting contact' do
    find_link(I18n.t('admin.buttons.delete_contact')).click
    using_wait_time 5 do
      expect(current_path).to eq admin_location_service_path(@location, @service)
      expect(page).not_to have_link 'Moncef Belyamani'
    end
  end
end
