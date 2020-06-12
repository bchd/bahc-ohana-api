class Flag < ApplicationRecord
  store_accessor :report, :report_attributes

  belongs_to :resource, polymorphic: true

  validates :email,
            format: { with: EMAIL_REGEX, message: 'wrong format' },
            if: ->(flag) { flag.email.present? }

  # validates_length_of :description, maximum: 250, allow_blank: false

  validate :check_report_attributes

  # Keep this method consistent with UI app too (in Flag model)
  def self.report_attributes_schema
    [
      {
        name: :hours_location_contact_info_incorrect,
        label: "Hours, Location, Contact info incorrect"
      },
      {
        name: :the_service_listed_are_incorrect,
        label: "The services listed are incorrect"
      },
      {
        name: :the_eligibility_how_to_access_or_waht_to_bring_is_incorrect,
        label: "The eligibility, how to access, or what to bring is incorrect"
      },
      {
        name: :other,
        label: "Other"
      },
      {
        name: :employee_of_the_org,
        label: "I am employee of the org"
      }
    ]
  end

  def self.get_report_attribute_label_for(attr)
    attribute = report_attributes_schema.find do |ar|
      ar[:name].to_s == attr[0]
    end

    if found_attribute
      found_attribute[:label]
    else
      attr[0]
    end
  end

  def resource_path
    paths = Rails.application.routes.url_helpers

    case resource_type
    when 'Location'
      paths.edit_admin_location_path(resource)
    when 'Organization'
      paths.edit_admin_organization_path(resource)
    when 'Service'
      paths.edit_admin_service_path(resource)
    end
  end

  private

  def check_report_attributes
    if report_attributes.nil? || report_attributes.all? {|k, v| v.blank? || v == "0" }
      errors.add(:report_attributes, "can't be blank")
    end
  end
end
