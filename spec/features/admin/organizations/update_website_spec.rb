require 'rails_helper'

feature 'Update website' do
  background do
    @org = create(:organization)
    login_super_admin
    visit '/admin/organizations/' + @org.slug
  end

  scenario 'with invalid website' do
    fill_in 'organization_website', with: 'www.monfresh.com'
    click_button I18n.t('admin.buttons.save_changes')
    expect(page).to have_content 'www.monfresh.com is not a valid URL'
    expect(page).to have_css('.field_with_errors')
  end

  scenario 'with valid website' do
    fill_in 'organization_website', with: 'http://codeforamerica.org'
    click_button I18n.t('admin.buttons.save_changes')
    expect(find_field('organization_website').value).
      to eq 'http://codeforamerica.org'
  end
end
