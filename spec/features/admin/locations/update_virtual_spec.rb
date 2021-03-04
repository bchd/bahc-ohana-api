require 'rails_helper'

feature 'Update virtual attribute' do
  background do
    @location = create(:location)
    login_super_admin
    visit '/admin/locations/' + @location.slug
  end

  scenario 'setting to true' do
    select('Does not have a physical address', from: 'location_virtual')
    click_button I18n.t('admin.buttons.save_changes')
    expect(find_field('location_virtual').value).to eq 'true'
  end
end
