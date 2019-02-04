class AddServiceRefToContacts < ActiveRecord::Migration[5.1]
  def change
    add_reference :contacts, :service, index: true
  end
end
