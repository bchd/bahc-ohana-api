require 'rails_helper'

feature 'Update accreditations' do
  background do
    @organization = create(:organization)
    login_super_admin
    visit '/admin/organizations/parent-agency'
  end

  scenario 'with one accreditation', :js do
    fill_in(placeholder: I18n.t('admin.organizations.forms.accreditations.placeholder'), with: "Knight Foundation Grant\n")
    click_button I18n.t('admin.buttons.save_changes')
    expect(@organization.reload.accreditations).to eq ['Knight Foundation Grant']
  end

  scenario 'with two accreditations', :js do
    fill_in(placeholder: I18n.t('admin.organizations.forms.accreditations.placeholder'), with: "first,second\n")
    click_button I18n.t('admin.buttons.save_changes')
    expect(@organization.reload.accreditations).to eq %w[first second]
  end

  scenario 'removing an accreditation', :js do
    @organization.update!(accreditations: %w[County Donations])
    visit '/admin/organizations/parent-agency'

    county = find('li', text: 'County')
    county.find('span', text: "\u{00D7}").click

    click_button I18n.t('admin.buttons.save_changes')
    expect(@organization.reload.accreditations).to eq ['Donations']
  end
end
