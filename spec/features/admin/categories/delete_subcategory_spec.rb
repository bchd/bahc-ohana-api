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

    # This extra accept_confirm is required because of a bug
    # Confirm dialog appears twice throughout the app 
    # This is a known issue and will be fixed in the future
    accept_confirm

    expect(page).to have_content "Category '#{@jobs_subcategory.name}' was successfully deleted."
  end
end