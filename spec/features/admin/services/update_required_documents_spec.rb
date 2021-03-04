require 'rails_helper'

feature 'Update required_documents' do
  background do
    @location = create_service.location
    login_super_admin
    visit '/admin/locations/' + @location.slug
    click_link 'Literacy Program'
  end

  scenario 'with no required_documents' do
    click_button I18n.t('admin.buttons.save_changes')
    expect(@service.reload.required_documents).to eq []
  end

  scenario 'with one required document', :js do
    fill_in(placeholder: I18n.t('admin.services.forms.required_documents.placeholder'), with: "Bank Statement\n")
    click_button I18n.t('admin.buttons.save_changes')
    expect(@service.reload.required_documents).to eq ['Bank Statement']
  end

  scenario 'with two required_documents', :js do
    fill_in(placeholder: I18n.t('admin.services.forms.required_documents.placeholder'), with: "Bank Statement\nPicture ID\n")
    click_button I18n.t('admin.buttons.save_changes')
    expect(@service.reload.required_documents).to eq ['Bank Statement', 'Picture ID']
  end

  scenario 'removing a required document', :js do
    @service.update!(required_documents: ['Bank Statement', 'Picture ID'])
    visit '/admin/locations/' + @location.slug
    click_link 'Literacy Program'

    banks_satement_choice = find('li', text: 'Bank Statement')
    banks_satement_choice.find('span', text: "\u{00D7}").click

    click_button I18n.t('admin.buttons.save_changes')
    expect(@service.reload.required_documents).to eq ['Picture ID']
  end
end
