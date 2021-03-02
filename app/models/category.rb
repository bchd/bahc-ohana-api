class Category < ApplicationRecord
  self.inheritance_column = nil
  has_many :services, through: :service_categories, touch: true

  scope :services, -> { where(type: 'service') }
  scope :situations, -> { where(type: 'situation') }

  validates :name, presence: { message: I18n.t('errors.messages.blank_for_category') }

  validates :taxonomy_id,
            uniqueness: {
              message: I18n.t('errors.messages.duplicate_taxonomy_id'),
              case_sensitive: false
  }, if: -> { taxonomy_id.present? }

  has_ancestry

  def resource_count
    services.count
  end
end
