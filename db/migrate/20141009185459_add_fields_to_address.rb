class AddFieldsToAddress < ActiveRecord::Migration[5.1]
  def change
    add_column :addresses, :country_code, :string, null: false
    add_column :addresses, :street_2, :string
    rename_column :addresses, :zip, :postal_code
    rename_column :addresses, :street, :street_1
  end
end
