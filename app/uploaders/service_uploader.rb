class ServiceUploader
  class ServiceUploadError < StandardError
  end

  def initialize(file_path)
    @file_path = file_path
  end

  def process
    csv = SmarterCSV.process(@file_path)
    Service.transaction do
      csv.map do |attributes|
        location = Location.find_by(id: attributes[:location_id])
        unless location
          raise ServiceUploadError, I18n.t(
            'admin.services.upload.location_not_found',
            location_id: attributes[:location_id]
          )
        end

        service = location.services.find_or_initialize_by(name: attributes[:service_name])

        service.name = attributes[:service_name]
        service.audience = attributes[:audience]
        service.description = attributes[:description]
        service.eligibility = attributes[:eligibility]
        service.languages = attributes[:languages_list].split(",").map(&:strip)
        service.address_details = attributes[:address_details]
        service.website = attributes[:website]
        service.email = attributes[:email]
        service.save

        if !service.persisted?
          raise ServiceUploadError, I18n.t(
            'admin.services.upload.validation_errors',
            errors: service.errors.full_messages.join(", "),
            location_id:service.location_id
          )
        end

        find_or_create_tags(service, attributes[:tags])

        find_or_create_contact(
          service,
          attributes[:contact_name],
          attributes[:contact_title],
          attributes[:contact_email]
        )

        service
      end
    end
  end

  private

  def find_or_create_tags(service, tags)
    return unless tags.present?

    tags.split(/\s*,\s*/).map do |tag|
      Tag.find_or_create_by(name: tag)
    end.map do |tag|
      TagResource.find_or_create_by(
        resource_id: service.id,
        tag_id: tag.id,
        resource_type: 'Service'
      )
    end
  end

  def find_or_create_contact(service, name, title, email)
    contact = Contact.find_or_initialize_by(name: name)
      contact.name = name
      contact.title = title
      contact.email = email
      contact.save
    if service.contacts.find_by(id: contact.id).nil?
      service.contacts << contact
    end
  end
end
