# frozen_string_literal: true

class LocationsIndex < Chewy::Index
  define_type Location do
    field :id, type: 'integer'
    field :organization_id, type: 'integer'
    field :name
    field :description
    field :created_at, type: 'date'
    field :updated_at, type: 'date'
    field :zipcode, value: -> { address.try(:postal_code) }
    field :keywords, value: -> { services.map(&:keywords).compact.join(', ') }
  end
end
