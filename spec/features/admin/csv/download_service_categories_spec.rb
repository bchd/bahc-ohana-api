require 'rails_helper'

feature 'Downloading Service Categories CSV' do
  before { login_super_admin }

  context 'services has non-empty array attributes' do
    before do
      @food = create(:category)
      @health = create(:health)
      @jobs = create(:jobs)
      @service = create(
        :service,
        category_ids: [@food.id, @health.id, @jobs.id]
      )

      @archived_service = create(
        :service,
        archived_at: DateTime.now
      )

      @unarchived_service_at_an_archived_location = create(
        :service,
        location: create(:location, archived_at: DateTime.now)
      )

      visit admin_csv_service_categories_path(format: 'csv')
    end

    it 'contains the same headers as in the service categories upload' do
      expect(csv.first).to eq %w[
      current_parent_categories name id location_name new_category new_subcategory clear_categories
      ]
    end

    it 'contains unarchived services' do
      expect(csv.second).to eq([
        @service.current_parent_categories, @service.name, @service.id.to_s, @service.location_name, "", "", ""
      ])
    end

    it 'does not contain unarchived services that belong to archived locations' do
      expect(csv.length).to eq(2)
    end
  end
end
