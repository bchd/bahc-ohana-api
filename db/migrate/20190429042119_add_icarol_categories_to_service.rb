class AddIcarolCategoriesToService < ActiveRecord::Migration[5.1]
  def change
    add_column :services, :icarol_categories, :string
  end
end
