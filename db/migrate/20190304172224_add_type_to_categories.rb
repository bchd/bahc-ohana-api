class AddTypeToCategories < ActiveRecord::Migration[5.1]
  def change
    add_column :categories, :type, :string
    Category.update_all( {type: 'service'} )
    change_column :categories, :type, :string, null: false
  end
end
