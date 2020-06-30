class TagResource < ApplicationRecord
  belongs_to :tag
  belongs_to :resource, polymorphic: true

  def self.get_resources (tag_id)
    query = where("tag_id = ?", tag_id).select(:resource_id, :resource_type)
    return query.pluck(:id, :resource_id, :resource_type)
  end
end
