require 'rails_helper'

feature 'Update date incorporated' do
  background do
    @org = create(:organization)
    login_super_admin
    visit '/admin/organizations/' + @org.slug
  end

  scenario 'date incorporated does not render' do
    expect(page).not_to have_css 'organization_date_incorporated_1i'
    expect(page).not_to have_css 'organization_date_incorporated_2i'
    expect(page).not_to have_css 'organization_date_incorporated_3i'
  end
end
