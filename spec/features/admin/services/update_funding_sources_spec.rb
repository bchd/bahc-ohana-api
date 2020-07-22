require 'rails_helper'

feature 'Update funding_sources' do
  background do
    create_service
    login_super_admin
    visit '/admin/locations/vrs-services'
    click_link 'Literacy Program'
  end

  scenario 'with no funding_sources' do
    click_button I18n.t('admin.buttons.save_changes')
    expect(@service.reload.funding_sources).to eq []
  end

  scenario 'with one accepted payment', :js do
    fill_in(placeholder: I18n.t('admin.shared.forms.funding_sources.placeholder'), with: "State\n")
    click_button I18n.t('admin.buttons.save_changes')
    expect(@service.reload.funding_sources).to eq ['State']
  end

  scenario 'with two funding_sources', :js do
    fill_in(placeholder: I18n.t('admin.shared.forms.funding_sources.placeholder'), with: "State\nCounty\n")
    click_button I18n.t('admin.buttons.save_changes')
    expect(@service.reload.funding_sources).to eq %w[State County]
  end

  scenario 'removing an accepted payment', :js do
    @service.update!(funding_sources: %w[State County])
    visit '/admin/locations/vrs-services'
    click_link 'Literacy Program'

    state = find('li', text: 'State')
    state.find('span', text: "\u{00D7}").click

    click_button I18n.t('admin.buttons.save_changes')
    expect(@service.reload.funding_sources).to eq ['County']
  end
end
