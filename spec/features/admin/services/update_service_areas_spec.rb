require 'rails_helper'

feature 'Update service areas' do
  background do
    location = create(:location)
    @service = location.services.
               create!(attributes_for(:service).merge(keywords: []))
    login_super_admin
    visit '/admin/locations/vrs-services'
    click_link 'Literacy Program'
  end

  scenario 'with one service area', :js do
    fill_in(placeholder: I18n.t('admin.services.forms.service_areas.placeholder'), with: "Belmont\n")
    click_button I18n.t('admin.buttons.save_changes')
    expect(@service.reload.service_areas).to eq ['Belmont']
  end

  scenario 'with two service areas', :js do
    fill_in(placeholder: I18n.t('admin.services.forms.service_areas.placeholder'), with: "Belmont\nAtherton\n")
    click_button I18n.t('admin.buttons.save_changes')
    expect(@service.reload.service_areas).to eq %w[Atherton Belmont]
  end

  scenario 'removing a service area', :js do
    @service.update!(service_areas: %w[Atherton Belmont])
    visit '/admin/locations/vrs-services'
    click_link 'Literacy Program'

    atherton = find('li', text: 'Atherton')
    atherton.find('span', text: "\u{00D7}").click

    click_button I18n.t('admin.buttons.save_changes')
    expect(@service.reload.service_areas).to eq ['Belmont']
  end
end
