require 'rails_helper'

feature 'Update wait_time' do
  background do
    create_service
    login_super_admin
    visit admin_capacity_path
  end

  scenario 'with valid wait_time' do
    select 'Available Today', from: 'wait_time'
    click_button I18n.t('admin.services.capacity.update_status')
    expect(find_field('wait_time').value).to eq 'available_today'
    expect(Service.first.wait_time).to eq 'available_today'
  end
end
