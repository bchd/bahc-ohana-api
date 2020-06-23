# frozen_string_literal: true
class LocationsIndex < Chewy::Index
  define_type Location.includes(:organization, :address, services: :categories) do
    field :archived_at, value: -> { archived_at? ? archived_at : nil }, type: 'date'
    field :archived, type: 'boolean', value: -> { !archived_at.nil? } 
    field :created_at, type: 'date'
    field :description
    field :id, type: 'integer'
    field :keywords, value: -> { services.map(&:keywords).compact.join(', ') }
    field :name
    field :organization_id, type: 'integer'
    field :organization_name, value: -> { organization.try(:name) }
    field :tags, value: -> { tags.map(&:name) }
    field :updated_at, type: 'date'
    field :zipcode, value: -> { address.try(:postal_code) }
    field :category_ids, value: -> { services.map(&:categories).flatten.uniq.map(&:id) }
    field :tags, value: -> { tags.map(&:name) }
    field :featured_at, type: 'date'
    field :covid19, value: -> { covid19? ? created_at : nil }, type: 'date'
  end
end

