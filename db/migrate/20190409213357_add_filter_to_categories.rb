class AddFilterToCategories < ActiveRecord::Migration[5.1]
  def change
    add_column :categories, :filter, :boolean, default: false
  end
end
