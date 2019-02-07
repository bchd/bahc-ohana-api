class AddContactRefToPhones < ActiveRecord::Migration[5.1]
  def change
    add_reference :phones, :contact, index: true
  end
end
