class AddAddressDetailsTextColumnToServices < ActiveRecord::Migration[5.1]
  def change
    add_column :services, :address_details, :text
  end
end
