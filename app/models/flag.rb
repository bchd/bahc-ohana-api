class Flag < ApplicationRecord
  store_accessor :report, :report_attributes

  belongs_to :resource, polymorphic: true

  validates :email,
            format: { with: EMAIL_REGEX, message: 'wrong format' },
            if: ->(flag) { flag.email.present? }

  # validates_length_of :description, maximum: 250, allow_blank: false

  validate :check_report_attributes

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
    if report_attributes.nil? || report_attributes.all? {|k, v| v["value"].blank? || v["value"] == "0" }
      errors.add(:report_attributes, "can't be blank")
    end
  end
end
