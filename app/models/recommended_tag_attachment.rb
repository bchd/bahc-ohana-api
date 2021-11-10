class RecommendedTagAttachment < ApplicationRecord
  belongs_to :recommended_tag
  belongs_to :tag
end
