require 'rails_helper'

# TODO: skipping all tests until user login revisited
#
feature 'Visit home page after signing in' do
  # The 'login_as' method is a Warden test helper that
  # allows you to simulate a user login without having
  # to fill in the sign in form every time. Since we're
  # not testing the signing in part of the app here, we
  # can take advantage of the Warden helper and speed up
  # our integration tests.

  # All other methods are part of the Capybara DSL
  # https://github.com/jnicklas/capybara
  background do
    user = FactoryBot.create(:user)
    login_as(user, scope: :user)
    visit '/'
  end

  xit 'does not include a link to the Docs page in the navigation' do
    within '.navbar' do
      expect(page).to_not have_link 'Docs'
    end
  end

  xit 'includes a link to the dev portal home page in the navigation' do
    within '.navbar' do
      expect(page).to have_link 'CHARMcare Data Developers', href: root_path
    end
  end

  xit 'includes a link to sign out in the navigation' do
    within '.navbar' do
      expect(page).
        to have_link I18n.t('navigation.sign_out'), href: destroy_user_session_path
    end
  end

  xit 'includes a link to the Edit Account page in the navigation' do
    within '.navbar' do
      expect(page).
        to have_link I18n.t('navigation.edit_account'), href: edit_user_registration_path
    end
  end

  xscenario "click 'view' link" do
    click_link I18n.t('links.view')
    expect(page).to have_content 'Developer Applications'
  end
end
