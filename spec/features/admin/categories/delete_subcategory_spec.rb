require 'rails_helper'

feature 'Delete Subcategory' do
  background do
    @jobs_category = create(:jobs)
    @jobs_subcategory = create(:category, ancestry: @jobs_category.id)
    login_super_admin
    visit '/admin/categories'
  end

  scenario 'delete subcategory', js: true do
    # click_on "Expand All"
    find_by_id("expand_all").click
    # click(id: "category-#{@jobs_subcategory.id}-delete")
    accept_confirm do
      find_by_id("category-#{@jobs_subcategory.id}-delete").click
    end

    expect(page).to have_content "Category '#{@jobs_subcategory.name}' was successfully deleted."
  end
end