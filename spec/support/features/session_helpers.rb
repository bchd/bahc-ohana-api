module Features
  # Helper methods you can use in specs to perform common and
  # repetitive actions.
  module SessionHelpers
    def login_admin
      @admin = FactoryBot.create(:admin)
      login_as(@admin, scope: :admin)
    end

    def login_as_admin(admin)
      login_as(admin, scope: :admin)
    end

    def login_super_admin
      @super_admin = FactoryBot.create(:super_admin)
      login_as(@super_admin, scope: :admin)
    end

    def login_user
      @user = FactoryBot.create(:user)
      login_as(@user, scope: :user)
    end

    def sign_in(email, password)
      visit new_user_session_path
      within('#new_user') do
        fill_in 'Email',    with: email
        fill_in 'Password', with: password
      end
      click_button I18n.t('navigation.sign_in')
    end

    def sign_in_admin(email, password)
      visit new_admin_session_path
      within('#new_admin') do
        fill_in 'admin_email',    with: email
        fill_in 'admin_password', with: password
      end
      click_button I18n.t('navigation.sign_in')
    end

    def sign_up(name, email, password, confirmation)
      visit new_user_registration_path
      fill_in 'user_name',                  with: name
      fill_in 'user_email',                 with: email
      fill_in 'user_password',              with: password
      fill_in 'user_password_confirmation', with: confirmation
      click_button I18n.t('navigation.sign_up')
    end

    def sign_up_admin(name, email, password, confirmation)
      visit new_admin_registration_path
      fill_in 'admin_name',                  with: name
      fill_in 'admin_email',                 with: email
      fill_in 'admin_password',              with: password
      fill_in 'admin_password_confirmation', with: confirmation
      click_button I18n.t('navigation.sign_up')
    end

    def csv
      CSV.parse(page.html)
    end
  end
end
