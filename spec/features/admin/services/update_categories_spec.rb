require 'rails_helper'

feature 'Update categories' do
  let(:emergency) { Category.create!(name: 'Emergency', taxonomy_id: '101', type: 'service') }
    
  before do
    @service = create_service
    @other_service = create(:service, name: "Something else")
    emergency.services = [@service, @other_service]
    @location = @service.location
    sub1 = emergency.children.create!(name: 'Disaster Response', taxonomy_id: '101-01', type: 'service')
    emergency.children.create!(name: 'Subcategory 2', taxonomy_id: '101-02', type: 'service')
    emergency.children.create!(name: 'Subcategory 3', taxonomy_id: '101-03', type: 'service')

    emergency.children.each{|cat| cat.services << @service}

    login_super_admin
    visit '/admin/locations/' + @location.slug
    click_link 'Literacy Program'
  end

  scenario 'updating service without changing categories' do
    fill_in 'service_name', with: ''
    fill_in 'service_description', with: ''
    click_button I18n.t('admin.buttons.save_changes')

    expect(page).to have_content("can't be blank")
  end

  scenario 'when adding one subcategory', :js do
    check "category_#{emergency.id}"
    check "category_#{emergency.children.first.id}"
    click_button I18n.t('admin.buttons.save_changes')

    expect(find("#category_#{emergency.id}")).to be_checked
    expect(find("#category_#{emergency.children.first.id}")).to be_checked

    uncheck "category_#{emergency.id}"
    click_button I18n.t('admin.buttons.save_changes')

    expect(find("#category_#{emergency.id}")).to_not be_checked
  end

  scenario 'when going to the 3rd subcategory', :js do
    check "category_#{emergency.id}"
    check "category_#{emergency.children.first.id}"
    check "category_#{emergency.children.second.id}"
    check "category_#{emergency.children.third.id}"

    click_button I18n.t('admin.buttons.save_changes')

    expect(find("#category_#{emergency.children.third.id}")).to be_checked
    expect(find("#category_#{emergency.children.second.id}")).to be_checked
    expect(find("#category_#{emergency.children.first.id}")).to be_checked
    expect(find("#category_#{emergency.id}")).to be_checked
  end
end
