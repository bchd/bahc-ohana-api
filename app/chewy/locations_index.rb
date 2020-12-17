# frozen_string_literal: true
class LocationsIndex < Chewy::Index

  settings analysis: {
    analyzer: {
      remove_stop_words: {
        type: "standard",
        stopwords: "_english_"
      }
    }
  }

  define_type Location.includes(:address, services: [:categories, :tags], organization: :tags) do
    field :accessibility
    field :archived_at, value: -> { archived_at? ? archived_at : nil }, type: 'date'
    field :archived, type: 'boolean', value: -> { !archived_at.nil? } 
    field :created_at, type: 'date'
    field :description, analyzer: 'remove_stop_words'
    field :id, type: 'integer'
    field :keywords, value: -> { services.map(&:keywords).compact.join(', ') }, analyzer: 'remove_stop_words'
    field :name, type: 'text', analyzer: 'remove_stop_words'
    field :name_exact, value: -> { name }
    field :organization_id, type: 'integer'
    field :organization_name, value: -> { organization.try(:name) }, analyzer: 'remove_stop_words'
    field :organization_tags, value: -> { organization.tags.pluck(:name) }
    field :organization_name_exact, value: -> { organization.try(:name) }
    field :updated_at, type: 'date'
    field :zipcode, value: -> { address.try(:postal_code) }
    field :category_ids, value: -> { services.map(&:categories).flatten.uniq.map(&:id) }
    field :categories, value: -> { services.map(&:categories).flatten.uniq.map(&:name) }
    field :categories_exact, value: -> { services.flat_map(&:categories).select { |cat| cat.ancestry.blank? }.uniq.map(&:name) }
    field :sub_categories_exact, value: -> { services.flat_map(&:categories).select { |cat| !cat.ancestry.blank? }.uniq.map(&:name) }
    field :tags, value: -> { tags.map(&:name) }
    field :featured_at, type: 'date'
    field :covid19, value: -> { covid19? ? created_at : nil }, type: 'date'
    field :service_tags, value: -> { services.map(&:tags).flatten.uniq.map(&:name) }
  end
end

