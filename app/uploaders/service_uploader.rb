class ServiceUploader
  class ServiceUploadError < StandardError
  end

  def initialize(file_path)
    @file_path = file_path.tempfile
  end

  def process
    csv = SmarterCSV.process(@file_path)
    Service.transaction do
      csv.each do |attributes|
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
        service.languages = [attributes[:languages_list]]
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

        service_tags_array = find_or_create_tags(service, attributes[:tags])

        find_or_create_contact(
          service.id,
          location.id,
          attributes[:contact_name],
          attributes[:contact_title],
          attributes[:contact_email]
        )
      end
    end
  end

  private

  def find_or_create_tags(service, tags)
    service_tags = []
    if tags.present?
      tag_array = tags.split(/\s*,\s*/)
      tag_array.each do |tag|
        result = Tag.find_or_create_by(name: tag)
        service_tags << result.id
      end
      find_or_create_tag_resources(service.id, service_tags)
    end
  end

  def find_or_create_tag_resources(service_id, service_tags_array)
    if !service_tags_array.empty?
      service_tags_array.each do |tag|
        TagResource.find_or_create_by(
          resource_id: service_id,
          tag_id: tag,
          resource_type: 'Service'
        )
      end
    end
  end

  def find_or_create_contact(service_id, location_id, name, title, email)
    if email.present?
      contact = Contact.find_or_create_by(email: email)
      contact.update({
        location_id: location_id,
        name: name,
        title: title,
        service_id: service_id
      })
    end
  end
end
