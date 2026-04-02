require 'rails_helper'

feature 'Delete Subcategory' do
  background do
    @jobs_category = create(:jobs)
    @jobs_subcategory = create(:category, ancestry: @jobs_category.id)
    login_super_admin
    visit '/admin/categories'
  end

  scenario 'delete subcategory', js: true do
    expect(page).to have_content @jobs_subcategory.name
    accept_confirm do
        click_link(href: "/admin/categories/#{@jobs_subcategory.id}")
    end
    expect(page).to have_content "Category '#{@jobs_subcategory.name}' was successfully deleted."
    expect(page).not_to have_content @jobs_subcategory.name
  end
end