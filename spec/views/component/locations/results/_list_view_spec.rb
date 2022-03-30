require 'rails_helper'

RSpec.describe 'component/locations/results/list_view', debt: true do
  let(:first_test_phone) do
    OpenStruct.new(
      id: 1001,
      department: nil,
      extension: nil,
      number: '111-111-1111',
      number_type: first_general_number_type,
      vanity_number: nil
    )
  end
  let(:second_test_phone) do
    OpenStruct.new(
      id: 1002,
      department: nil,
      extension: nil,
      number: '222-222-2222',
      number_type: second_general_number_type,
      vanity_number: nil
    )
  end
  let(:third_test_phone) do
    OpenStruct.new(
      id: 1003,
      department: nil,
      extension: nil,
      number: '333-333-3333',
      number_type: third_general_number_type,
      vanity_number: nil
    )
  end
  let(:fourth_test_phone) do
    OpenStruct.new(
      id: 1004,
      department: nil,
      extension: nil,
      number: '444-444-4444',
      number_type: fourth_general_number_type,
      vanity_number: nil
    )
  end
  let(:test_phones) do
    [
      first_test_phone,
      second_test_phone,
      third_test_phone,
      fourth_test_phone
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
      name: 'Example Agency',
      website: 'http://example.org',
      slug: 'example-agency',
      url: 'http://lvh.me:8080/api/organizations/example-agency',
      locations_url: 'http://lvh.me:8080/api/organizations/example-agency/locations'
    )
  end
  let(:test_locations) do
    [
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
        website: 'http://www.example.org',
        updated_at: '2018-02-14 18:02:36 -0800',
        url: 'http://lvh.me:8080/api/locations/example-location',
        address: test_address,
        organization: test_organization,
        phones: test_phones
      )
    ]
  end
  let(:test_search) do
    OpenStruct.new(
      locations: test_locations,
      results: OpenStruct.new(
        total_pages: 1,
        current_page: 1
      )
    )
  end

  before do
    render 'component/locations/results/list_view', search: test_search
  end

  context 'when the voice number is first' do
    let(:first_general_number_type)  { 'voice' }
    let(:second_general_number_type) { 'hotline' }
    let(:third_general_number_type)  { 'fax' }
    let(:fourth_general_number_type) { 'tty' }

    it 'will display the first voice number' do
      expect(rendered).to have_content('(111) 111-1111')
    end
  end

  context 'when the hotline number is first' do
    let(:first_general_number_type)  { 'hotline' }
    let(:second_general_number_type) { 'voice' }
    let(:third_general_number_type)  { 'fax' }
    let(:fourth_general_number_type) { 'tty' }

    it 'will display the first hotline number' do
      expect(rendered).to have_content('(111) 111-1111')
    end
  end

  context 'when the fax number is first and voice is second' do
    let(:first_general_number_type)  { 'fax' }
    let(:second_general_number_type) { 'voice' }
    let(:third_general_number_type)  { 'hotline' }
    let(:fourth_general_number_type) { 'tty' }

    it 'will display the first voice number' do
      expect(rendered).to have_content('(222) 222-2222')
    end
  end

  context 'when the fax number is first and hotline is second' do
    let(:first_general_number_type)  { 'fax' }
    let(:second_general_number_type) { 'hotline' }
    let(:third_general_number_type)  { 'voice' }
    let(:fourth_general_number_type) { 'tty' }

    it 'will display the first hotline number' do
      expect(rendered).to have_content('(222) 222-2222')
    end
  end

  context 'when only a fax number is present' do
    let(:first_general_number_type)  { 'fax' }
    let(:second_general_number_type) { 'fax' }
    let(:third_general_number_type)  { 'fax' }
    let(:fourth_general_number_type) { 'tty' }

    it 'will not display any number' do
      expect(rendered).not_to match(/\(\d{3}\) \d{3}-\d{4}/)
    end
  end
end
