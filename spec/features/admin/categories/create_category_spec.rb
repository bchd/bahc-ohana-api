require 'rails_helper'

feature 'Create Category' do
  background do
    @category = create(:category)
    login_super_admin
    visit '/admin/categories'
  end

  scenario 'with valid name' do
    click_link "Add New Category"
    fill_in 'category_name', with: 'Youth Counseling'
    click_button 'Save'
    expect(page).to have_content "Category 'Youth Counseling' was successfully created."
  end
end
