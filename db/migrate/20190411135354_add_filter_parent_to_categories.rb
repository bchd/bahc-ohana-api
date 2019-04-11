class AddFilterParentToCategories < ActiveRecord::Migration[5.1]
  def change
    add_column :categories, :filter_parent, :boolean, default: false
  end
end
