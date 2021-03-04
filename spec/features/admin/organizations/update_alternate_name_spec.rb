require 'rails_helper'

feature 'Update alternate name' do
  background do
    org = create(:organization)
    login_super_admin
    visit '/admin/organizations/' + org.slug
  end

  scenario 'with alternate name' do
    fill_in 'organization_alternate_name', with: 'Juvenile Sexual Responsibility Program'
    click_button I18n.t('admin.buttons.save_changes')
    expect(find_field('organization_alternate_name').value).
      to eq 'Juvenile Sexual Responsibility Program'
  end
end
