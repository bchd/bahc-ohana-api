require 'rails_helper'

feature 'Update funding_sources' do
  background do
    @organization = create(:organization)
    login_super_admin
    visit '/admin/organizations/parent-agency'
  end

  scenario 'with no funding_sources' do
    click_button I18n.t('admin.buttons.save_changes')
    expect(@organization.reload.funding_sources).to eq []
  end

  scenario 'with one funding source', :js do
    fill_in(placeholder: I18n.t('admin.shared.forms.funding_sources.placeholder'), with: "State\n")
    click_button I18n.t('admin.buttons.save_changes')
    expect(@organization.reload.funding_sources).to eq ['State']
  end

  scenario 'with two funding_sources', :js do
    fill_in(placeholder: I18n.t('admin.shared.forms.funding_sources.placeholder'), with: "State\nCounty\n")
    click_button I18n.t('admin.buttons.save_changes')
    expect(@organization.reload.funding_sources).to eq %w[State County]
  end

  scenario 'removing a funding source', :js do
    @organization.update!(funding_sources: %w[State County])
    visit '/admin/organizations/parent-agency'

    state = find('li', text: 'State')
    state.find('span', text: "\u{00D7}").click

    click_button I18n.t('admin.buttons.save_changes')
    expect(@organization.reload.funding_sources).to eq ['County']
  end
end
