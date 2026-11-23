require 'rails_helper'

feature 'Visit home page after signing in' do
  background do
    login_user
    visit '/'
  end

  it 'includes a link to the Favorites page in the header' do
    within '#content-header' do
      expect(page).to have_link I18n.t('navigation.favorites'), href: '/favorites', visible: :all
    end
  end

  it 'includes a link to sign out in the header' do
    within '#content-header' do
      expect(page).
        to have_link I18n.t('navigation.sign_out'), href: destroy_user_session_path, visible: :all
    end
  end

  it 'includes a link to the Account Details page in the header' do
    within '#content-header' do
      expect(page).
        to have_link I18n.t('navigation.account_details'), href: edit_user_registration_path, visible: :all
    end
  end
end
