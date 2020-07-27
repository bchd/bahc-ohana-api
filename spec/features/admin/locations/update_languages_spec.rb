require 'rails_helper'

feature 'Update languages' do
  background do
    @location = create(:location)
    login_super_admin
    visit '/admin/locations/vrs-services'
  end

  scenario 'with no languages' do
    click_button I18n.t('admin.buttons.save_changes')
    expect(@location.reload.languages).to eq []
  end

  scenario 'with one language', :js do
    fill_in(placeholder: I18n.t('admin.locations.forms.languages.placeholder'), with: "French\n")
    click_button I18n.t('admin.buttons.save_changes')
    expect(@location.reload.languages).to eq ['French']
  end

  scenario 'with two languages', :js do
    fill_in(placeholder: I18n.t('admin.locations.forms.languages.placeholder'), with: "French\nSpanish\n")
    click_button I18n.t('admin.buttons.save_changes')
    expect(@location.reload.languages).to eq %w[French Spanish]
  end

  scenario 'removing a language', :js do
    @location.update!(languages: %w[Arabic French])
    visit '/admin/locations/vrs-services'

    arabic = find('li', text: 'Arabic')
    arabic.find('span', text: "\u{00D7}").click

    click_button I18n.t('admin.buttons.save_changes')
    expect(@location.reload.languages).to eq ['French']
  end
end
