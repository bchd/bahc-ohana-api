require 'rails_helper'

feature 'Update tax status' do
  background do
    @org = create(:organization)
    login_super_admin
    visit '/admin/organizations/' + @org.slug
  end

  scenario 'with tax status' do
    fill_in 'organization_tax_status', with: '501(c)(3)'
    click_button I18n.t('admin.buttons.save_changes')
    expect(find_field('organization_tax_status').value).to eq '501(c)(3)'
  end
end
