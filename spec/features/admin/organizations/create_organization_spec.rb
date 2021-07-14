require 'rails_helper'

feature 'Create a new organization' do
  background do
    create(:organization)
    login_super_admin
    visit('/admin/organizations/new')
  end

  scenario 'with all required fields' do
    fill_in 'organization_name', with: 'new org'
    fill_in 'organization_description', with: 'description for new org'
    click_button I18n.t('admin.buttons.create_organization')
    click_link 'new org'

    expect(find_field('organization_name').value).to eq 'new org'
    expect(find_field('organization_description').value).to eq 'description for new org'
  end

  scenario 'without any required fields' do
    click_button I18n.t('admin.buttons.create_organization')
    expect(page).to have_content "Name can't be blank for Organization"
    expect(page).to have_content "Description can't be blank for Organization"
  end

  scenario 'when adding a website' do
    fill_in 'organization_name', with: 'new org'
    fill_in 'organization_description', with: 'description for new org'
    fill_in 'organization_website', with: 'http://ruby.com'
    click_button I18n.t('admin.buttons.create_organization')
    click_link 'new org'

    expect(find_field('organization_website').value).to eq 'http://ruby.com'
  end

  scenario 'when adding an alternate name' do
    fill_in 'organization_name', with: 'new org'
    fill_in 'organization_description', with: 'description for new org'
    fill_in 'organization_alternate_name', with: 'AKA'
    click_button I18n.t('admin.buttons.create_organization')
    click_link 'new org'

    expect(find_field('organization_alternate_name').value).to eq 'AKA'
  end

  scenario 'when adding an email' do
    fill_in 'organization_name', with: 'new org'
    fill_in 'organization_description', with: 'description for new org'
    fill_in 'organization_email', with: 'foo@bar.com'
    click_button I18n.t('admin.buttons.create_organization')
    click_link 'new org'

    expect(find_field('organization_email').value).to eq 'foo@bar.com'
  end

  scenario 'when adding a legal status' do
    fill_in 'organization_name', with: 'new org'
    fill_in 'organization_description', with: 'description for new org'
    fill_in 'organization_legal_status', with: 'non-profit'
    click_button I18n.t('admin.buttons.create_organization')
    click_link 'new org'

    expect(find_field('organization_legal_status').value).to eq 'non-profit'
  end

  scenario 'when adding a tax status' do
    fill_in 'organization_name', with: 'new org'
    fill_in 'organization_description', with: 'description for new org'
    fill_in 'organization_tax_status', with: '501(c)(3)'
    click_button I18n.t('admin.buttons.create_organization')
    click_link 'new org'

    expect(find_field('organization_tax_status').value).to eq '501(c)(3)'
  end

  scenario 'when adding multiple accreditations', :js do
    fill_in 'organization_name', with: 'new org'
    fill_in 'organization_description', with: 'description for new org'
    fill_in(placeholder: I18n.t('admin.organizations.forms.accreditations.placeholder'), with: "first,second\n")
    click_button I18n.t('admin.buttons.create_organization')

    organization = Organization.find_by(name: 'new org')
    expect(organization.accreditations).to eq %w[first second]
  end
end
