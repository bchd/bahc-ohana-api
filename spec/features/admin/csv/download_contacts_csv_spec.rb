require 'rails_helper'

feature 'Downloading Contacts CSV' do
  before do
    login_super_admin
    @location = create(:location)
    @contact = create(
      :contact_with_extra_whitespace,
    )
    ResourceContact.create(
      contact: @contact,
      resource: @location
    )
    visit admin_csv_contacts_path(format: 'csv')
  end

  it 'contains the same headers as in the import Wiki' do
    expect(csv.first).to eq %w[id resource_id resource_type name
                               title email department]
  end

  it 'populates contact attribute values' do
    expect(csv.second).to eq [
      @contact.id.to_s, @location.id.to_s, 'Location',
      'Foo', 'Bar', 'foo@bar.com', 'Screening'
    ]
  end
end

feature 'Downloading contact CSV for contact with no resources' do
  before do
    login_super_admin
    @contact = create(
      :contact_with_extra_whitespace,
    )
    visit admin_csv_contacts_path(format: 'csv')
  end

  it 'populats contact attribute values' do
    expect(csv.second).to eq [
      @contact.id.to_s, nil, nil,
      'Foo', 'Bar', 'foo@bar.com', 'Screening'
    ]
  end
end
