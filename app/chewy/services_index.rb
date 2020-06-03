# frozen_string_literal: true

class ServicesIndex < Chewy::Index
  define_type Service.includes(:location) do
    field :id, type: 'integer'
    field :location_id, type: 'integer'
    field :name
    field :description
    field :created_at, type: 'date'
    field :updated_at, type: 'date'
    field :zipcode, value: -> { location.try(:address).try(:postal_code) }
    field :keywords, value: -> { keywords.compact.join(', ') }
    field :tags, value: -> { tags.map(&:name) }
  end
end
