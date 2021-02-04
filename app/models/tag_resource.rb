class TagResource < ApplicationRecord
  # We want to skip organization because the index does not exist
  # Keep this up to date with any taggable resource
  update_index(-> (tag_resource) {
    case tag_resource.resource_type 
    when "Location" then "locations#location"
    when "Service" then "services#service"
    end
  }) do
    return nil if self.resource_type == "Organization"
    self.resource
  end

  belongs_to :tag
  belongs_to :resource, polymorphic: true

  def self.get_resources (tag_id)
    where("tag_id = ?", tag_id).select(:resource_id, :resource_type)
  end
end
