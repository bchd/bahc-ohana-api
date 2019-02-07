class AddCountryPrefixToPhones < ActiveRecord::Migration[5.1]
  def change
    add_column :phones, :country_prefix, :string
  end
end
