require 'rails_helper'
require 'spec_helper'

feature 'Search services' do
  background do
    service = FactoryBot.create(
      :service,
      name: "Literacy Program",
      updated_at: DateTime.new(2019,7,8)
    )
    tag = FactoryBot.create(:tag, name: "Education")
    FactoryBot.create(:tag_resource, tag: tag, resource: service)
    login_super_admin
    visit '/admin/services'
  end

  scenario 'with keyword search' do
    fill_in 'q[keyword]', with: 'Literacy'
    click_button I18n.t('admin.buttons.search')
    expect(page).to have_content "Literacy Program"
  end

  scenario 'with start date search' do
    fill_in 'q[start_date]', with: '2019-07-01'
    click_button I18n.t('admin.buttons.search')
    expect(page).to have_content "Literacy Program"
  end

  scenario 'with updated at search' do
    fill_in 'q[start_date]', with: '2019-07-01'
    fill_in 'q[end_date]', with: '2019-08-01'
    click_button I18n.t('admin.buttons.search')
    expect(page).to have_content "Literacy Program"
  end

  scenario 'with tag search' do
    select('Education', from: 'q[tag]')
    click_button I18n.t('admin.buttons.search')
    expect(page).to have_content "Literacy Program"
  end
end
