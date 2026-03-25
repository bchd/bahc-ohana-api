require 'rails_helper'

feature 'Categories page' do
  context 'when not signed in' do
    before do
      visit '/admin/categories'
    end

    it 'redirects to the admin sign in page' do
      expect(current_path).to eq(new_admin_session_path)
    end

    it 'prompts the user to sign in or sign up' do
      expect(page).
        to have_content 'You need to sign in or sign up before continuing.'
    end

    it 'does not include a link to categories in the navigation' do
      within '.navbar' do
        expect(page).not_to have_link I18n.t('admin.buttons.categories'), href: admin_categories_path
      end
    end
  end

  context 'when signed in as admin' do
    before do
      login_admin
      visit '/admin/categories'
    end

    it 'does not include a link to categories in the navigation' do
      within '.navbar' do
        expect(page).not_to have_link I18n.t('admin.buttons.categories'), href: admin_categories_path
      end
    end
  end

  context 'when signed in as super admin' do
    before do
      @health_category = create(:health, ancestry: nil)
      @jobs_category = create(:jobs, ancestry: nil)
      @jobs_subcategory = create(:category, ancestry: @jobs_category.id.to_s)

      login_super_admin
      visit '/admin/categories'
    end

    it 'displays instructions for editing categories' do
      expect(page).to have_content 'As a super admin'
    end

    it 'shows all categories' do
      expect(page).to have_content @health_category.name
      expect(page).to have_content @jobs_category.name
    end

    it 'shows subcategories' do
      expect(page).to have_content @jobs_subcategory.name
    end
  end
end
