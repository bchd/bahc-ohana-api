class AddTypeToCategories < ActiveRecord::Migration[5.1]
  def change
    add_column :categories, :type, :string
  end
end
