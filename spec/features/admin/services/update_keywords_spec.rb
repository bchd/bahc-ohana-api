require 'rails_helper'

feature 'Update keywords' do
  background do
    location = create(:location)
    @service = location.services.create!(
      attributes_for(:service).merge(keywords: [])
    )
    login_super_admin
    visit '/admin/locations/vrs-services'
    click_link 'Literacy Program'
  end

  scenario 'with one keyword', :js do
    fill_in(placeholder: I18n.t('admin.services.forms.keywords.placeholder'), with: "ligal\n")
    click_button I18n.t('admin.buttons.save_changes')
    expect(@service.reload.keywords).to eq ['ligal']
  end

  scenario 'with two keywords', :js do
    fill_in(placeholder: I18n.t('admin.services.forms.keywords.placeholder'), with: "first,second\n")
    click_button I18n.t('admin.buttons.save_changes')
    expect(@service.reload.keywords).to eq %w[first second]
  end

  scenario 'removing a keyword', :js do
    @service.update!(keywords: %w[resume computer])
    visit '/admin/locations/vrs-services'
    click_link 'Literacy Program'

    resume = find('li', text: 'resume')
    resume.find('span', text: "\u{00D7}").click

    click_button I18n.t('admin.buttons.save_changes')
    expect(@service.reload.keywords).to eq ['computer']
  end
end
