class AddOrganizationRefToContacts < ActiveRecord::Migration[5.1]
  def change
    add_reference :contacts, :organization, index: true
  end
end
