require 'rails_helper'

feature 'Uploading Services CSV' do
  before do
    create(:location, id: 1)
    login_super_admin
    visit admin_csv_downloads_path
  end

  it 'allows file to be uploaded successfully' do
    page.attach_file("services", Rails.root.join("spec", "support", "fixtures", "service_upload.csv"))
    find('#service-upload-btn').click
    expect(page).to have_content 'Success! Service upload complete'
  end
end
