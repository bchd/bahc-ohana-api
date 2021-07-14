require 'rails_helper'

feature 'Update date incorporated' do
  background do
    @org = create(:organization)
    login_super_admin
    visit '/admin/organizations/' + @org.slug
  end

  scenario 'date incorporated does not render' do
    expect(page.should_not have_css('organization_date_incorporated_1i')).
      to eq(true)
    expect(page.should_not have_css('organization_date_incorporated_2i')).
      to eq(true)
    expect(page.should_not have_css('organization_date_incorporated_3i')).
      to eq(true)
  end
end
