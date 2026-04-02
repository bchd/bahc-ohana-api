require 'rails_helper'

feature 'Create Subcategory' do
  background do
    @category = create(:jobs)
    login_super_admin
    visit '/admin/categories'
  end

  scenario 'with valid name' do
    click_link "Add New Jobs Subcategory"
    expect(page).to have_content "New Jobs Subcategory"
    fill_in 'category_name', with: 'Jobs Subcategory'
    click_button 'Save'
    expect(page).to have_content "Category 'Jobs Subcategory' was successfully created."
  end
end
