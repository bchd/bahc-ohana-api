class FlagCategory < ApplicationRecord
  has_and_belongs_to_many :flags

  validates :name,
            uniqueness: { case_sensitive: false },
            presence: true

  validates_length_of :name, maximum: 25, allow_blank: false
end
