ContactPresenter = Struct.new(:row) do

  def to_contact
    contact = Contact.find_or_initialize_by(id: row[:id].to_i)
    contact.attributes = contact_attributes(row)
    association_id(row).each do |contact_id|
      resource = contact.resource_contact.find_or_create_by(
        resource_type:
          contact_id
          .to_s
          .first(contact_id.length - 3)
          .capitalize,
        resource_id: contact_id
      )
    end
    contact
  end

  def association_id(row)
    row.select { |id| !id}
  end

  def contact_attributes(row)
    row.except(:organization_id, :location_id, :service_id)
  end
end