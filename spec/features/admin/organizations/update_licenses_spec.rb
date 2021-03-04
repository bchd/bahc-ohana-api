require 'rails_helper'

feature 'Update licenses' do
  background do
    @organization = create(:organization)
    login_super_admin
    visit('/admin/organizations/'+ @organization.slug) 
  end

  scenario 'with one license', :js do
    fill_in(placeholder: I18n.t('admin.organizations.forms.licenses.placeholder'), with: "Knight Foundation Grant,")
    click_button I18n.t('admin.buttons.save_changes')
    expect(@organization.reload.licenses).to eq ['Knight Foundation Grant']
  end

  scenario 'with two licenses', :js do
    fill_in(placeholder: I18n.t('admin.organizations.forms.licenses.placeholder'), with: "first,second\n")
    click_button I18n.t('admin.buttons.save_changes')
    expect(@organization.reload.licenses).to eq %w[first second]
  end

  scenario 'removing a license', :js do
    @organization.update!(licenses: %w[County Donations])
    visit('/admin/organizations/'+ @organization.slug) 

    county = find('li', text: 'County')
    county.find('span', text: "\u{00D7}").click

    click_button I18n.t('admin.buttons.save_changes')
    expect(@organization.reload.licenses).to eq ['Donations']
  end
end
