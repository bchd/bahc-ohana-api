class Location < ApplicationRecord
  def real_updated_at
    date = updated_at

    if address.present?
      date = address.updated_at if address.updated_at > date
    end

    if contacts.any?
      contacts.each do |contact|
        date = contact.updated_at if contact.updated_at > date
      end
    end

    if phones.any?
      phones.each do |phone|
        date = phone.updated_at if phone.updated_at > date
      end
    end

    if services.any?
      services.each do |service|
        date = service.updated_at if service.updated_at > date
      end
    end

    date
  end

  update_index('locations#location') { self }

  belongs_to :organization, touch: true, optional: false

  has_one :address, dependent: :destroy
  accepts_nested_attributes_for :address, allow_destroy: true

  has_many :contacts, dependent: :destroy

  has_many :phones, dependent: :destroy, inverse_of: :location
  accepts_nested_attributes_for :phones,
                                allow_destroy: true, reject_if: :all_blank

  has_many :services, dependent: :destroy

  has_many :regular_schedules, dependent: :destroy, inverse_of: :location
  accepts_nested_attributes_for :regular_schedules,
                                allow_destroy: true, reject_if: :all_blank

  has_many :holiday_schedules, dependent: :destroy, inverse_of: :location
  accepts_nested_attributes_for :holiday_schedules,
                                allow_destroy: true, reject_if: :all_blank

  has_many :tag_resources, as: :resource
  has_many :tags, through: :tag_resources, source: :tag

  validates :address,
            presence: { message: I18n.t('errors.messages.no_address') },
            unless: :virtual?

  validates :description, :name,
            presence: { message: I18n.t('errors.messages.blank_for_location') }

  ## Uncomment the line below if you want to require a short description.
  ## We recommend having a short description so that web clients can display
  ## an overview within the search results. See smc-connect.org as an example.
  # validates :short_desc, presence: { message: I18n.t('errors.messages.blank_for_location') }

  ## Uncomment the line below if you want to limit the
  ## short description's length. If you want to display a short description
  ## on a front-end client like smc-connect.org, we recommmend writing or
  ## re-writing a description that's one to two sentences long, with a
  ## maximum of 200 characters. This is just a recommendation though.
  ## Feel free to modify the maximum below, and the way the description is
  ## displayed in the ohana-web-search client to suit your needs.

  validates :short_desc, length: { maximum: 200 }

  validates :website, url: true, allow_blank: true

  validates :languages, pg_array: true

  validates :admin_emails, array: { email: true }

  validates :email, email: true, allow_blank: true

  after_validation :geocode, if: :needs_geocoding?

  geocoded_by :full_physical_address

  extend Enumerize
  serialize :accessibility, Array
  # Don't change the terms here! You can change their display
  # name in config/locales/en.yml
  enumerize :accessibility,
            in: %i[cd deaf_interpreter disabled_parking elevator ramp
                   restroom tape_braille tty wheelchair wheelchair_van],
            multiple: true

  auto_strip_attributes :description, :email, :name, :short_desc,
                        :transportation, :website

  auto_strip_attributes :admin_emails, reject_blank: true, nullify: false

  extend FriendlyId
  friendly_id :slug_candidates, use: [:history]

  # Try building a slug based on the following fields in
  # increasing order of specificity.
  def slug_candidates
    [
      :name,
      %i[name address_street],
      %i[name]
    ]
  end

  def address_street
    address.address_1 if address.present?
  end

  def full_physical_address
    return if address.blank?

    "#{address.address_1}, #{address.city}, #{address.state_province} #{address.postal_code}"
  end

  def needs_geocoding?
    return false if address.blank? || address.marked_for_destruction?
    return true if latitude.blank? && longitude.blank?

    address.changed? && !address.new_record?
  end

  def covid19?
    name.match(/covid/i).present?
  end

  # See app/models/concerns/search.rb
  include Search
end
