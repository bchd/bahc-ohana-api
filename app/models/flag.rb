class Flag < ApplicationRecord
  store_accessor :report, :report_attributes

  belongs_to :resource, polymorphic: true

  validates :email,
            format: { with: EMAIL_REGEX, message: 'wrong format' },
            if: ->(flag) { flag.email.present? }

  # validates_length_of :description, maximum: 250, allow_blank: false

  validate :check_report_attributes

  after_initialize :set_default_report_attributes

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

  def set_default_report_attributes
    self.report_attributes = {} if self.report_attributes.nil?
  end

  def check_report_attributes
    if report_attributes.nil? || report_attributes.all? {|k, v| v["value"].blank? || v["value"] == "0" }
      errors.add(:report_attributes, "can't be blank")
    end
  end


  #pulling in the below from UI
  extend ActiveModel::Naming
  include ActiveModel::AttributeMethods
  include ActiveModel::Model


  def self.report_attributes_schema
    [
      {
        name: :hours_location_contact_info_incorrect,
        label: "The hours, location, or contact information is incorrect."
      },
      {
        name: :the_service_listed_are_incorrect,
        label: "Information listed on this resource page is incorrect."
      },
      {
        name: :other,
        label: "Other"
      },
      {
        name: :employee_of_the_org,
        label: "I am an employee of this organization.",
        details_required: false
      },
      {
        name: :contact_me,
        label: "Yes, I agree to have a CHARMcare representative contact me regarding this resource.",
        details_required: false
      }
    ]
  end

  def self.details_required?(attr_name)
    puts attr_name
    get_schema_attribute_by_name(attr_name)[:details_required] != false
  end

  def self.get_schema_attribute_by_name(name)
    attribute = report_attributes_schema.find do |ar|
      ar[:name] == name
    end

    attribute
  end

  def self.report_attributes_in_order
    Flag.report_attributes_schema.collect(&:values).transpose[0]
  end

  def self.get_report_attribute_label_for(attr)
    attribute = report_attributes_schema.find do |ar|
      ar[:name].to_s.include?(attr)
    end

    attribute ? attribute[:label] : attr[0]
  end
end
