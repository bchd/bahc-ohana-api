class Tag < ApplicationRecord
  has_many :tag_resources, dependent: :destroy
end
