class TagResource < ApplicationRecord
  belongs_to :tag
  belongs_to :resource, polymorphic: true
end
