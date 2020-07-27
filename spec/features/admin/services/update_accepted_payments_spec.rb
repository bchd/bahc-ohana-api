require 'rails_helper'

feature 'Update accepted_payments' do
  background do
    create_service
    login_super_admin
    visit '/admin/locations/vrs-services'
    click_link 'Literacy Program'
  end

  scenario 'with no accepted_payments' do
    click_button I18n.t('admin.buttons.save_changes')
    expect(@service.reload.accepted_payments).to eq []
  end

  scenario 'with one accepted payment', :js do
    fill_in(placeholder: I18n.t('admin.services.forms.accepted_payments.placeholder'), with: "Cash\n")
    click_button I18n.t('admin.buttons.save_changes')
    expect(@service.reload.accepted_payments).to eq ['Cash']
  end

  scenario 'with two accepted_payments', :js do
    fill_in(placeholder: I18n.t('admin.services.forms.accepted_payments.placeholder'), with: "Cash\nCheck\n")
    click_button I18n.t('admin.buttons.save_changes')
    expect(@service.reload.accepted_payments).to eq %w[Cash Check]
  end

  scenario 'removing an accepted payment', :js do
    @service.update!(accepted_payments: %w[Cash Check])
    visit '/admin/locations/vrs-services'
    click_link 'Literacy Program'

    cash = find('li', text: 'Cash')
    cash.find('span', text: "\u{00D7}").click

    click_button I18n.t('admin.buttons.save_changes')
    expect(@service.reload.accepted_payments).to eq ['Check']
  end
end
