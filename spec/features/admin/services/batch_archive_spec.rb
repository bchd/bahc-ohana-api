require 'rails_helper'

feature 'Archive a service' do
  background do
    @location = create(:location)
    @service = @location.services.create!(attributes_for(:service).merge!(name: 'Book Bus'))
    @service = @location.services.create!(attributes_for(:service).merge!(name: 'Vocational Service'))
    login_super_admin
    visit '/admin/services'
  end

  scenario 'by select all', js: true do
    check "Select all on page"

    click_button I18n.t('admin.buttons.batch_archive_services')

    expect(page).to have_content 'Archive successful.'
  end
end
