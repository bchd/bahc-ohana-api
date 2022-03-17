require 'rails_helper'

describe 'PATCH contact' do
  before do
    @loc = create(:location)
    @contact = @loc.contacts.create!(attributes_for(:contact))
    @attrs = { name: 'Moncef', title: 'Consultant', email: 'bar@foo.com' }
  end

  describe 'PATCH /locations/:location_id/contacts/:id' do
    it 'returns 200 when validations pass' do
      patch(
        api_location_contact_url(@loc, @contact),
        @attrs
      )
      expect(response).to have_http_status(200)
    end

    it 'returns the updated contact when validations pass' do
      patch(
        api_location_contact_url(@loc, @contact),
        @attrs
      )
      expect(json['title']).to eq 'Consultant'
    end

    it "updates the location's contact" do
      patch(
        api_location_contact_url(@loc, @contact),
        @attrs
      )
      get api_location_url(@loc)
      expect(json['contacts'].first['email']).to eq 'bar@foo.com'
    end

    it "doesn't add a new contact" do
      expect {
        patch(
          api_location_contact_url(@loc, @contact),
          @attrs
        )
      }.to change {
        Contact.count
      }.by(0)
    end

    it 'requires a valid contact id' do
      patch(
        api_location_contact_url(@loc, 123),
        @attrs
      )
      expect(response.status).to eq(404)
      expect(json['message']).
        to include 'The requested resource could not be found.'
    end

    it 'returns 422 when attribute is invalid' do
      patch(
        api_location_contact_url(@loc, @contact),
        @attrs.merge!(name: '')
      )
      expect(response.status).to eq(422)
      expect(json['message']).to eq('Validation failed for resource.')
      expect(json['errors'].first).
        to eq('name' => ["can't be blank for Contact"])
    end

    it "doesn't allow updating a contact without a valid token" do
      patch(
        api_location_contact_url(@loc, @contact),
        @attrs,
        'HTTP_X_API_TOKEN' => 'invalid_token'
      )
      expect(response.status).to eq(401)
    end
  end
end
