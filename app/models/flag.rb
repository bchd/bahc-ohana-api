class Flag < ApplicationRecord
 validates :email,
           format: { with: EMAIL_REGEX, message: "Wrong Format"},
           if: -> (flag) { flag.email.present? }

 validates_length_of :description, maximum: 250, allow_blank: false

  def resource
    resource_type.constantize.find(resource_id)
  end

  def resource_path
    paths = Rails.application.routes.url_helpers
    case resource_type
    when 'Location'
      paths.edit_admin_location_path(resource)
    when 'Organization'
      paths.edit_admin_organization_path(resource)
    when 'Services'
      paths.edit_admin_service_path(resource)
    end
  end
end
