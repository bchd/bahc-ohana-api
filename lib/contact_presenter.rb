ContactPresenter = Struct.new(:row) do

  def to_contact
    if row[:id].present?
      contact = Contact.find_or_initialize_by(id: row[:id].to_i)
    else
      contact = Contact.find_or_initialize_by(name: row[:name])
    end
    contact.attributes = contact_attributes(row)

    if row[:resource_id].present? && row[:resource_type].present?
      resource = contact.resource_contacts.find_or_initialize_by(
        resource_type: row[:resource_type],
        resource_id: row[:resource_id],
      )
      resource.save
    end
    contact
  end

  def contact_attributes(row)
    row.except(:id, :resource_type, :resource_id)
  end
end