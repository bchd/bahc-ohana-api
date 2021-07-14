require 'rails_helper'

feature 'Create a new service' do
  background do
    @location = create(:location)
    login_super_admin
    visit '/admin/locations/' + @location.slug
    click_link I18n.t('admin.buttons.add_service')
  end

  scenario 'with all required fields', :js do
    fill_in_required_service_fields

    click_button I18n.t('admin.buttons.create_service')

    click_link 'New VRS Services service'

    expect(find_field('service_name').value).to eq 'New VRS Services service'

    within '.CodeMirror' do
      expect(current_scope).to have_content 'new description'
    end
  end

  scenario 'without any required fields' do
    click_button I18n.t('admin.buttons.create_service')
    expect(page).to have_content "Description can't be blank for Service"
    expect(page).to have_content "Name can't be blank for Service"
  end

  scenario 'with alternate_name', :js do
    fill_in_required_service_fields
    fill_in 'service_alternate_name', with: 'Alternate name'

    click_button I18n.t('admin.buttons.create_service')
    click_link 'New VRS Services service'

    expect(find_field('service_alternate_name').value).to eq 'Alternate name'
  end

  scenario 'with audience', :js do
    fill_in_required_service_fields
    fill_in 'service_audience', with: 'Low-income residents.'
    click_button I18n.t('admin.buttons.create_service')
    click_link 'New VRS Services service'

    expect(find_field('service_audience').value).to eq 'Low-income residents.'
  end

  scenario 'with eligibility', :js do
    fill_in_required_service_fields
    fill_in 'service_eligibility', with: 'Low-income residents.'
    click_button I18n.t('admin.buttons.create_service')
    click_link 'New VRS Services service'

    expect(find_field('service_eligibility').value).to eq 'Low-income residents.'
  end

  scenario 'with email', :js do
    fill_in_required_service_fields
    fill_in 'service_email', with: 'foo@bar.com'
    click_button I18n.t('admin.buttons.create_service')
    click_link 'New VRS Services service'

    expect(find_field('service_email').value).to eq 'foo@bar.com'
  end

  scenario 'with fees', :js do
    fill_in_required_service_fields
    fill_in 'service_fees', with: 'Low-income residents.'
    click_button I18n.t('admin.buttons.create_service')
    click_link 'New VRS Services service'

    expect(find_field('service_fees').value).to eq 'Low-income residents.'
  end

  scenario 'with application_process', :js do
    fill_in_required_service_fields
    fill_in 'service_application_process', with: 'Low-income residents.'
    click_button I18n.t('admin.buttons.create_service')
    click_link 'New VRS Services service'

    expect(find_field('service_application_process').value).to eq 'Low-income residents.'
  end

  scenario 'when adding a language', :js do
    fill_in_required_service_fields
    fill_in(placeholder: I18n.t('admin.services.forms.languages.placeholder'), with: "French\n")
    click_button I18n.t('admin.buttons.create_service')
    click_link 'New VRS Services service'

    service = Service.find_by(name: 'New VRS Services service')
    expect(service.languages).to eq ['French']
    expect(find('#service_languages', visible: false).value).to eq(['French'])
  end

  scenario 'when adding a service area', :js do
    fill_in_required_service_fields
    fill_in(placeholder: I18n.t('admin.services.forms.service_areas.placeholder'), with: "Belmont\n")
    click_button I18n.t('admin.buttons.create_service')
    click_link 'New VRS Services service'

    expect(find('#service_service_areas', visible: false).value).
      to eq(['Belmont'])
  end

  scenario 'when adding a website', :js do
    fill_in_required_service_fields
    fill_in 'service_website', with: 'http://ruby.com'
    click_button I18n.t('admin.buttons.create_service')
    click_link 'New VRS Services service'

    expect(find_field('service_website').value).to eq 'http://ruby.com'
  end

  scenario 'when adding categories', :js do
    other_service = create_service
    emergency = Category.create!(name: 'Emergency', taxonomy_id: '101', type: 'service')
    emergency.services << other_service
    emergency.children.create!(name: 'Disaster Response', taxonomy_id: '101-01', type: 'service')
    emergency.children.last.services << other_service
    emergency.children.create!(name: 'Subcategory 2', taxonomy_id: '101-02', type: 'service')
    emergency.children.last.services << other_service
    visit '/admin/locations/' + @location.slug + '/services/new'

    fill_in_required_service_fields
    check "category_#{emergency.id}"
    check "category_#{emergency.children.first.id}"
    click_button I18n.t('admin.buttons.create_service')
    click_link 'New VRS Services service'

    expect(find("#category_#{emergency.id}")).to be_checked
    expect(find("#category_#{emergency.children.first.id}")).to be_checked
  end

  scenario 'when adding hours of operation', :js do
    fill_in_required_service_fields
    add_hour(
      weekday: 'Tuesday',
      opens_at_hour: '9 AM', opens_at_minute: '30',
      closes_at_hour: '5 PM', closes_at_minute: '45'
    )
    click_button I18n.t('admin.buttons.create_service')
    click_link 'New VRS Services service'

    prefix = 'service_regular_schedules_attributes_0'

    expect(find_field("#{prefix}_weekday").value).to eq '2'

    expect(find_field("#{prefix}_opens_at_4i").value).to eq '09'
    expect(find_field("#{prefix}_opens_at_5i").value).to eq '30'

    expect(find_field("#{prefix}_closes_at_4i").value).to eq '17'
    expect(find_field("#{prefix}_closes_at_5i").value).to eq '45'
  end

  scenario 'when adding holiday schedule', :js do
    fill_in_required_service_fields
    add_holiday_schedule(
      start_month: 'January',
      start_day: '1',
      end_month: 'January',
      end_day: '2',
      closed: 'Closed'
    )
    click_button I18n.t('admin.buttons.create_service')
    click_link 'New VRS Services service'

    prefix = 'service_holiday_schedules_attributes_0'

    expect(find_field("#{prefix}_start_date_2i").value).to eq '1'
    expect(find_field("#{prefix}_start_date_3i").value).to eq '1'

    expect(find_field("#{prefix}_end_date_2i").value).to eq '1'
    expect(find_field("#{prefix}_end_date_3i").value).to eq '2'

    expect(find_field("#{prefix}_closed").value).to eq 'true'

    expect(find_field("#{prefix}_opens_at_4i").value).to eq ''
    expect(find_field("#{prefix}_opens_at_5i").value).to eq ''

    expect(find_field("#{prefix}_closes_at_4i").value).to eq ''
    expect(find_field("#{prefix}_closes_at_5i").value).to eq ''
  end

  scenario 'when copying the service to other locations', :js do
    @new_loc = create(:far_loc, organization_id: @location.organization.id)
    visit '/admin/locations/' + @location.slug + '/services/new'
    fill_in_required_service_fields
    check 'Belmont Farmers Market'
    click_button I18n.t('admin.buttons.create_service')

    expect(page).to have_content 'successfully created'
    expect(@new_loc.reload.services.pluck(:name)).to eq ['New VRS Services service']
  end
end

describe 'when admin does not have access to the location' do
  it 'denies access to create a new service' do
    @location = create(:location)
    login_admin

    visit '/admin/locations/' + @location.slug + '/services/new'

    expect(page).to have_content I18n.t('admin.not_authorized')
  end
end
