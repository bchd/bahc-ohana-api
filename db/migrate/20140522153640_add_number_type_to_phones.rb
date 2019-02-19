class AddNumberTypeToPhones < ActiveRecord::Migration[5.1]
  def change
    add_column :phones, :number_type, :string
  end
end
