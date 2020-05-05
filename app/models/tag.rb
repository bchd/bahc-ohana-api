class Tag < ApplicationRecord
  has_many :tag_resources, dependent: :destroy

  default_scope { order("tags.created_at ASC") }
end
