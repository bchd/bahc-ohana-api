class LocationsSerializer < ActiveModel::Serializer
  attributes :id, :active, :admin_emails, :alternate_name, :coordinates,
             :description, :latitude, :longitude, :name, :short_desc, :slug,
             :website, :updated_at, :url, :featured, :languages

  has_one :address
  has_one :organization, serializer: LocationsOrganizationSerializer
  has_many :phones

  def coordinates
    return [] unless object.longitude.present? && object.latitude.present?

    [object.longitude, object.latitude]
  end

  def languages
    return object.services.map(&:languages).concat(object.languages).flatten.uniq.reject(&:blank?)
  end  

  def url
    api_location_url(object)
  end
end
