class Contact < ApplicationRecord

  default_scope { order('id ASC') }

  has_many :resource_contacts, dependent: :destroy
  has_many :organizations, through: :resource_contacts, source: :resource, source_type: Organization.to_s
  has_many :locations, through: :resource_contacts, source: :resource, source_type: Location.to_s
  has_many :services, through: :resource_contacts, source: :resource, source_type: Service.to_s

  has_many :phones, dependent: :destroy, inverse_of: :contact
  accepts_nested_attributes_for :phones,
                                allow_destroy: true, reject_if: :all_blank

  validates :name,
            presence: { message: I18n.t('errors.messages.blank_for_contact') }

  validates :email, email: true, allow_blank: true

  auto_strip_attributes :department, :email, :name, :title, squish: true
end
