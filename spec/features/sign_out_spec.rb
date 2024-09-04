require 'rails_helper'

feature 'Signing out' do
  background do
    login_user
    visit edit_user_registration_path
  end

  # CHANGED: reflecting that in combined app, not all users are admins, so signout should redirect to root
  it 'redirects to the user home page' do
    if page.has_css?('.desktop-only')
      within('.profile-dropdown') do
        click_link I18n.t('navigation.sign_out')
      end
    else
      within('.mobile-only.dropdown-menu') do
        click_link I18n.t('navigation.sign_out')
      end
    end
    expect(current_path).to eq(root_path)
  end
end
