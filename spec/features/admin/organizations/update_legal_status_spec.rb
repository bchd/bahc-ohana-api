require 'rails_helper'

feature 'Update legal status' do
  background do
    @org = create(:organization)
    login_super_admin
    visit '/admin/organizations/' + @org.slug
  end

  scenario 'with legal status' do
    fill_in 'organization_legal_status', with: 'non-profit'
    click_button I18n.t('admin.buttons.save_changes')
    expect(find_field('organization_legal_status').value).to eq 'non-profit'
  end
end
