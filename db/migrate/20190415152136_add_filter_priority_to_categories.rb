class AddFilterPriorityToCategories < ActiveRecord::Migration[5.1]
  def change
    add_column :categories, :filter_priority, :int, default: nil
  end
end
