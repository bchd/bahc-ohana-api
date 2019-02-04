class AddFieldsToMailAddress < ActiveRecord::Migration[5.1]
  def change
    add_column :mail_addresses, :country_code, :string, null: false
    add_column :mail_addresses, :street_2, :string
    rename_column :mail_addresses, :zip, :postal_code
    rename_column :mail_addresses, :street, :street_1
  end
end
