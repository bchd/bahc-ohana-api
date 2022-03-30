require 'rails_helper'

RSpec.describe 'component/locations/results/list_view' do
  let(:first_test_phone) do
    OpenStruct.new(
      id: 1001,
      department: nil,
      extension: nil,
      number: '111-111-1111',
      number_type: 'voice',
      vanity_number: nil
    )
  end
  let(:second_test_phone) do
    OpenStruct.new(
      id: 1002,
      department: nil,
      extension: nil,
      number: '222-222-2222',
      number_type: 'hotline',
      vanity_number: nil
    )
  end
  let(:third_test_phone) do
    OpenStruct.new(
      id: 1003,
      department: nil,
      extension: nil,
      number: '333-333-3333',
      number_type: 'fax',
      vanity_number: nil
    )
  end
  let(:test_phones) do
    [
      first_test_phone,
      second_test_phone,
      third_test_phone
    ]
  end
  let(:test_address) do
    OpenStruct.new(
      id: 21,
      address_1: '2013 Avenue of the fellows',
      address_2: 'Suite 100',
      city: 'San Francisco',
      state_province: 'CA',
      postal_code: '94103'
    )
  end
  let(:test_organization) do
    OpenStruct.new(
      id: 8,
      accreditations: %w[BBB State\ Board\ of\ Education],
      alternate_name: 'Alternate Agency Name',
      date_incorporated: '1970-01-01',
      description: 'Sample organization description.',
      email: 'info@example.org',
      funding_sources: %w[State Donations Grants],
      licenses: [
        'State Health Inspection License',
        'State Board of Education License'
      ],
      name: organization_name,
      website: 'http://example.org',
      slug: 'example-agency',
      url: 'http://lvh.me:8080/api/organizations/example-agency',
      locations_url: 'http://lvh.me:8080/api/organizations/example-agency/locations'
    )
  end
  let(:test_location) do
    OpenStruct.new(
      id: 1,
      active: true,
      admin_emails: ['foo@bar.com'],
      alternate_name: 'The Test Spot',
      coordinates: [-122.4099154, 37.7726402],
      description: '[NOTE THIS IS NOT A REAL ORGANIZATION--THIS IS FOR TESTTING PURPOSES OF THIS ALPHA APP]',
      latitiude: 37.7726402,
      longitude: -122.4099154,
      name: 'Example Location',
      short_description: '[NOTE THIS IS NOT A REAL ORGANIZATION]',
      slug: 'example-location',
      tags: [OpenStruct.new(name: "Test Tag"), OpenStruct.new(name: "Test Tag")],
      website: 'http://www.example.org',
      updated_at: Date.parse('2018-02-14 18:02:36 -0800'),
      url: 'http://lvh.me:8080/api/locations/example-location',
      address: test_address,
      organization: test_organization,
      phones: test_phones,
      fields: []
    )
  end

  before do
    @location = test_location # necessary since module MailtoHelper references the instance var
    render 'component/locations/detail/body', location: test_location
  end

  context 'when the organization name is safe' do
    let(:organization_name) { 'The 1st, 2nd, 3rd, and 4th of 25th st & broad rd' }
    it 'will render the name as is' do
      expect(rendered).to have_content(organization_name)
    end
  end

  context 'when the organization name is not safe' do
    let(:organization_name) { '<script>var x=12;var y=34;document.body.innerHTML=x+y;</script>' }
    it 'will render the name as is' do
      expect(rendered).to have_content(organization_name)
    end
    it 'will not execute injected javascript' do
      expect(rendered).not_to have_content('46')
    end
  end
end
