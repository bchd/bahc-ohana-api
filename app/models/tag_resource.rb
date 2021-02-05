class TagResource < ApplicationRecord
  # We want to skip organization because the index does not exist
  # Keep this up to date with any taggable resource
  
  belongs_to :tag
  belongs_to :resource, polymorphic: true, touch: true

  def self.get_resources (tag_id)
    where("tag_id = ?", tag_id).select(:resource_id, :resource_type)
  end
end
