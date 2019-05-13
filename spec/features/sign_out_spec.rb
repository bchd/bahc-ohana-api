require 'rails_helper'

feature 'Signing out' do
  background do
    login_user
    visit edit_user_registration_path
  end

  # TODO: currently redirecting root to admin sign in.
  it 'redirects to the user home page' do
    click_link I18n.t('navigation.sign_out')
    expect(current_path).to eq(new_admin_session_path)
    # expect(current_path).to eq(root_path)
  end
end
