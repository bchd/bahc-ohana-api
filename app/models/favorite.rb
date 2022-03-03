class Favorite < ApplicationRecord
  belongs_to :user
  validates :url, presence: true
  validates :name, presence: true
end
