class AddTypeToCategories < ActiveRecord::Migration[5.1]
  def up
    add_column :categories, :type, :string
    Category.update_all( {type: 'service'} )
    change_column :categories, :type, :string
  end
  def down
    remove_column :categories, :type, :string
  end
end
