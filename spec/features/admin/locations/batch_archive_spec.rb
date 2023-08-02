require 'rails_helper'

feature 'Archive a location' do
  background do
    @loc1 = create(:location, name: 'Location 1')
    @loc2 = create(:location_with_admin, name: 'Location 2')
  end

  scenario 'not accessible to regular admin' do
    login_admin
    visit '/admin/locations'
    assert page.has_no_css?('.archive-btn')
  end

  scenario 'accessible to super admin' do
    login_super_admin
    visit '/admin/locations'
    assert page.has_css?('.archive-btn')
  end

  scenario 'by select all', js: true, debt: true do
    login_super_admin
    visit '/admin/locations'
    find("input[type='checkbox'][value='#{@loc2.id}']").set(true)

    accept_confirm("Are you sure you want to archive the selected items?") do
      click_button I18n.t('admin.buttons.batch_archive_locations')
    end

    assert page.has_content?('Archive successful.')
  end

  scenario 'by select all', js: true, debt: true do
    login_super_admin
    visit '/admin/locations'
    check "Select all on page"

    accept_confirm("Are you sure you want to archive the selected items?") do
      click_button I18n.t('admin.buttons.batch_archive_locations')
    end

    assert page.has_content?('Archive successful.')
  end
end
