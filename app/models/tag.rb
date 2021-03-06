class Tag < ApplicationRecord
  has_many :tag_resources, dependent: :destroy

  default_scope { order('tags.created_at ASC') }

  validates :name, presence: true
  validates :name, uniqueness: true

  def self.get_resources_by_tag_id (tag_id)
    TagResource.where(tag_id: tag_id).includes(:resource).all
  end

  def self.with_name_or_id(keyword)
    if keyword.present?
      where("tags.id = ? OR tags.name ILIKE ?", keyword.to_i, "%#{keyword}%" )
    else
      all
    end
  end
end
