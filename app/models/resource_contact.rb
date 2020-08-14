class ResourceContact < ApplicationRecord
  belongs_to :contact
  belongs_to :resource, polymorphic: true
end