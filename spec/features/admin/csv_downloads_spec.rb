require 'rails_helper'

feature 'Admin CSV Downloads page' do
  context 'when not signed in' do
    before :each do
      visit '/admin/csv_downloads'
    end

    it 'sets the current path to the admin sign in page' do
      expect(current_path).to eq(new_admin_session_path)
    end
  end

  context 'when signed in as admin' do
    before :each do
      login_admin
      visit '/admin/csv_downloads'
    end

    it 'sets the current path to the admin sign in page' do
      expect(current_path).to eq(admin_dashboard_path)
    end

    it 'does not includes a link to csv downloads in the navigation' do
      within '.navbar' do
        expect(page).not_to have_link I18n.t('admin.buttons.csv_downloads'),
                                      href: admin_csv_downloads_path
      end
    end
  end

  context 'when signed in as super admin' do
    before :each do
      login_super_admin
      visit '/admin/csv_downloads'
    end

    it 'displays link to download all tables as CSV files' do
      expect(page).to have_content 'CSV Downloads'

      tables = %w[addresses contacts holiday_schedules locations mail_addresses
                  organizations phones regular_schedules services]
      tables.each do |table|
        expect(page).
          to have_link t("admin.buttons.download_#{table}"), href: send(:"admin_csv_#{table}_url")
      end
    end
  end
end
