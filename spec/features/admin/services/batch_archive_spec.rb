require 'rails_helper'

feature 'Archive a service' do
  background do
    @location = create(:location)
    @service = @location.services.create!(attributes_for(:service).merge!(name: 'Book Bus'))
    @service = @location.services.create!(attributes_for(:service).merge!(name: 'Vocational Service'))
  end

  scenario 'not accessible to regular admin' do
    login_admin
    visit '/admin/services'
    assert page.has_no_css?('.archive-btn')
  end

  scenario 'accessible to super admin' do
    login_super_admin
    visit '/admin/services'
    assert page.has_css?('.archive-btn')
  end

  scenario 'by select all', js: true, debt: true do
    login_super_admin
    visit '/admin/services'

    check "Select all on page"

    accept_alert("Are you sure you want to archive the selected items?") do
      click_button I18n.t('admin.buttons.batch_archive_services')
    end

    assert page.has_content?('Archive successful.')
  end
end
