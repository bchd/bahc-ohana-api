require 'rails_helper'

describe 'GET /locations/:id' do
  context 'with valid id' do
    before do
      create_service
      @location.reload
      get api_location_url(@location)
    end

    it 'includes the location id' do
      expect(json['id']).to eq(@location.id)
    end

    it 'includes the accessibility attribute with localized text' do
      expect(json['accessibility']).to eq(@location.accessibility.map(&:text))
    end

    it 'includes the alternate_name attribute' do
      expect(json['alternate_name']).to eq(@location.alternate_name)
    end

    it 'includes the coordinates attribute' do
      expect(json['coordinates']).
        to eq([@location.longitude, @location.latitude])
    end

    it 'includes the description attribute' do
      expect(json['description']).to eq(@location.description)
    end

    it 'does not include the hours attribute' do
      expect(json.keys).not_to include('hours')
    end

    it 'includes the latitude attribute' do
      expect(json['latitude']).to eq(@location.latitude)
    end

    it 'includes the longitude attribute' do
      expect(json['longitude']).to eq(@location.longitude)
    end

    it 'includes the name attribute' do
      expect(json['name']).to eq(@location.name)
    end

    it 'includes the short_desc attribute' do
      expect(json['short_desc']).to eq(@location.short_desc)
    end

    it 'includes the slug attribute' do
      expect(json['slug']).to eq(@location.slug)
    end

    it 'includes the updated_at attribute' do
      expect(json.keys).to include('updated_at')
    end

    it 'includes the url attribute' do
      expect(json['url']).to eq(api_location_url(@location))
    end

    it 'includes the serialized address association' do
      serialized_address =
        {
          'id' => @location.address.id,
          'address_1' => @location.address.address_1,
          'address_2' => nil,
          'city' => @location.address.city,
          'state_province' => @location.address.state_province,
          'postal_code' => @location.address.postal_code
        }
      expect(json['address']).to eq(serialized_address)
    end

    it 'includes the serialized services association' do
      @service.regular_schedules.create!(attributes_for(:regular_schedule))
      @service.holiday_schedules.create!(attributes_for(:holiday_schedule))

      service_formatted_time = @service.reload.updated_at.
                               strftime('%Y-%m-%dT%H:%M:%S.%3N%:z')

      get api_location_url(@location)

      serialized_services =
        [{
          'id' => @location.services.reload.first.id,
          'accepted_payments' => [],
          'alternate_name' => nil,
          'audience' => nil,
          'description' => @location.services.first.description,
          'address_details' => nil,
          'eligibility' => nil,
          'email' => nil,
          'fees' => nil,
          'funding_sources' => [],
          'application_process' => @location.services.first.application_process,
          'interpretation_services' => @location.services.first.interpretation_services,
          'keywords' => @location.services.first.keywords,
          'languages' => [],
          'name' => @location.services.first.name,
          'required_documents' => [],
          'service_areas' => [],
          'status' => @location.services.first.status,
          'website' => nil,
          'wait_time' => nil,
          'wait_time_updated_at' => nil,
          'updated_at' => service_formatted_time,
          'categories' => [],
          'contacts' => [],
          'phones' => [],
          'regular_schedules' => [
            {
              'weekday' => 7,
              'opens_at' => '2000-01-01T09:30:00.000Z',
              'closes_at' => '2000-01-01T17:00:00.000Z'
            }
          ],
          'holiday_schedules' => [
            {
              'closed' => true,
              'start_date' => '2014-12-24',
              'end_date' => '2014-12-24',
              'label' => nil,
              'opens_at' => nil,
              'closes_at' => nil
            }
          ]
        }]

      expect(json['services']).to eq(serialized_services)
    end

    it 'includes the serialized organization association' do
      org = @location.organization

      serialized_organization =
        {
          'id' => @location.organization.id,
          'alternate_name' => nil,
          'name' => org.name,
          'slug' => org.slug,
          'url' => api_organization_url(org)
        }

      expect(json['organization']).to eq(serialized_organization)
    end

    it 'displays contacts when present' do
      @location.contacts.create!(attributes_for(:contact))
      get api_location_url(@location)
      expect(json['contacts']).
        to eq(
          [{
            'id' => @location.contacts.first.id,
            'email' => nil,
            'name' => @location.contacts.first.name,
            'department' => nil,
            'title' => @location.contacts.first.title,
            'phones' => @location.contacts.first.phones
          }]
        )
    end

    it 'displays phones when present' do
      @location.phones.create!(attributes_for(:phone))
      get api_location_url(@location)
      expect(json['phones']).
        to eq(
          [{
            'id' => @location.phones.first.id,
            'department' => @location.phones.first.department,
            'extension' => @location.phones.first.extension,
            'number' => @location.phones.first.number,
            'number_type' => @location.phones.first.number_type,
            'vanity_number' => @location.phones.first.vanity_number
          }]
        )
    end

    it 'includes the serialized regular_schedules association' do
      @location.regular_schedules.create!(attributes_for(:regular_schedule))
      get api_location_url(@location)

      serialized_regular_schedule =
        {
          'weekday' => 7,
          'opens_at' => '2000-01-01T09:30:00.000Z',
          'closes_at' => '2000-01-01T17:00:00.000Z'
        }
      expect(json['regular_schedules'].first).to eq(serialized_regular_schedule)
    end

    it 'includes the serialized holiday_schedules association' do
      @location.holiday_schedules.create!(attributes_for(:holiday_schedule))
      get api_location_url(@location)

      serialized_holiday_schedule =
        {
          'closed' => true,
          'start_date' => '2014-12-24',
          'end_date' => '2014-12-24',
          'label' => nil,
          'opens_at' => nil,
          'closes_at' => nil
        }
      expect(json['holiday_schedules'].first).to eq(serialized_holiday_schedule)
    end

    it 'is json' do
      expect(response.content_type).to eq('application/json; charset=utf-8')
    end

    it 'returns a successful status code' do
      expect(response).to have_http_status(200)
    end
  end

  context 'with invalid id' do
    before do
      get api_location_url(1)
    end

    it 'returns a status key equal to 404' do
      expect(json['status']).to eq(404)
    end

    it 'returns a helpful message' do
      expect(json['message']).
        to eq('The requested resource could not be found.')
    end

    it 'returns a 404 status code' do
      expect(response).to have_http_status(404)
    end

    it 'is json' do
      expect(response.content_type).to eq('application/json; charset=utf-8')
    end
  end

  context 'with nil fields' do
    before do
      @loc = create(:loc_with_nil_fields)
    end

    it 'returns nil fields when visiting one location' do
      get api_location_url(@loc)
      %w[admin_emails email accessibility].each do |key|
        expect(json.keys).to include(key)
      end
    end
  end

  describe 'ordering service categories by taxonomy_id' do
    before do
      @food = create(:category)
      @food_child = @food.children.
                    create!(name: 'Community Gardens', taxonomy_id: '101-01', type: 'service')
      @health = create(:health)
      @health_child = @health.children.
                      create!(name: 'Orthodontics', taxonomy_id: '102-01', type: 'service')
      create_service
      @service.category_ids = [
        @food.id, @food_child.id, @health.id, @health_child.id
      ]
    end

    it 'orders the categories by taxonomy_id' do
      get api_location_url(@location)

      categories = [
        {
          'id' => @food.id,
          'filter' => false,
          'filter_parent' => false,
          'filter_priority' => nil,
          'depth' => 0,
          'taxonomy_id' => '101',
          'name' => 'Food',
          'parent_id' => nil,
          'type' => 'service'
        },
        {
          'id' => @food_child.id,
          'filter' => false,
          'filter_parent' => false,
          'filter_priority' => nil,
          'depth' => 1,
          'taxonomy_id' => '101-01',
          'name' => 'Community Gardens',
          'parent_id' => @food.id,
          'type' => 'service'
        },
        {
          'id' => @health.id,
          'filter' => false,
          'filter_parent' => false,
          'filter_priority' => nil,
          'depth' => 0,
          'taxonomy_id' => '102',
          'name' => 'Health',
          'parent_id' => nil,
          'type' => 'service'
        },
        {
          'id' => @health_child.id,
          'filter' => false,
          'filter_parent' => false,
          'filter_priority' => nil,
          'depth' => 1,
          'taxonomy_id' => '102-01',
          'name' => 'Orthodontics',
          'parent_id' => @health.id,
          'type' => 'service'
        }
      ]

      expect(json['services'].first['categories']).to eq(categories)
    end
  end
end
