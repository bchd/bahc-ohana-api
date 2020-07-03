require 'rails_helper'
require 'spec_helper'

feature 'Search locations' do
  background do
    location = FactoryBot.create(
      :location,
      name: "VRS Services",
      updated_at: DateTime.new(2019,7,8)
    )
    tag = FactoryBot.create(:tag, name: "VRS")
    FactoryBot.create(:tag_resource, tag: tag, resource: location)
    login_super_admin
    visit '/admin/locations'
  end

  scenario 'by keyword in name' do
    fill_in 'q[keyword]', with: 'vrs'
    click_button I18n.t('admin.buttons.search')
    expect(page).to have_content "VRS Services"
  end

  scenario 'by keyword in name' do
    fill_in 'q[keyword]', with: 'food'
    click_button I18n.t('admin.buttons.search')
    expect(page).not_to have_content "VRS Services"
  end

  scenario 'with start date search' do
    fill_in 'q[start_date]', with: '2019-07-01'
    click_button I18n.t('admin.buttons.search')
    expect(page).to have_content "VRS Services"
  end

  scenario 'by updated at date' do
    fill_in 'q[start_date]', with: '2019-07-01'
    fill_in 'q[end_date]', with: '2019-08-01'
    click_button I18n.t('admin.buttons.search')
    expect(page).to have_content "VRS Services"
  end

  scenario 'by tag' do
    select('VRS', from: 'q[tag]')
    click_button I18n.t('admin.buttons.search')
    expect(page).to have_content "VRS Services"
  end
end
