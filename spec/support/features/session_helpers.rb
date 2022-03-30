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

    # Search helpers.
    def search(options = {})
      fill_in 'keyword', with: options[:keyword]
      fill_in 'location', with: options[:location]
      fill_in 'org_name', with: options[:org_name]
      find('#button-search').click
    end

    # Search from homepage.
    # @param options [Object] Hash containing keyword to search for.
    def search_from_home(options = {})
      visit('/')
      fill_in 'keyword', with: options[:keyword]
      find('#button-search').click
    end

    # Perform a search that returns 1 result.
    def search_for_example
      visit('/locations?keyword=example')
    end

    # Visit details page.
    def visit_test_location
      visit('/locations/example-location')
    end

    # Perform search that returns 1 result that has no address.
    def search_for_location_without_address
      visit('locations?org_name=Location+with+no+phone')
    end

    # Visit details page that has no address.
    def visit_location_with_no_address
      visit('locations/location-with-no-phone')
    end

    # Perform a search that returns no results.
    def search_for_no_results
      visit('/locations?keyword=asdfdsggfdg')
    end

    # Navigation helpers.
    def visit_details
      page.find('#list-view').first('a').click
    end

    def looks_like_results
      expect(page).to have_content('Example Agency')
      expect(page).to have_content('1 result')
      expect(page).to have_title 'Search results for: keyword: example'
    end

    def looks_like_no_results
      expect(page).to have_selector('.no-results')
      expect(page).to have_content('your search returned no results.')
      expect(page).not_to have_selector('#map-canvas')
    end

    def go_to_next_page
      first('.pagination').find_link('>').click
    end

    def go_to_prev_page
      first('.pagination').find_link('<').click
    end

    def go_to_page(page)
      first('.pagination').find_link(page).click
    end

    # Helper to (hopefully) wait for page to load.
    def delay
      sleep(2)
    end

  end
end
