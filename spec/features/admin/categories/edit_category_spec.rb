require 'rails_helper'

feature 'Update name' do
  background do
    @category = create(:category)
    login_super_admin
    visit '/admin/categories'
  end

  scenario 'with valid name' do
    click_link(href: "/admin/categories/#{@category.id}/edit")
    fill_in 'category_name', with: 'Youth Counseling'
    click_button 'Save'
    expect(page).to have_content 'Category was successfully updated.'
    expect(page).to have_content 'Youth Counseling'
  end
end
