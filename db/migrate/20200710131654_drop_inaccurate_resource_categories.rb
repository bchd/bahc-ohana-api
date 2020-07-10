class DropInaccurateResourceCategories < ActiveRecord::Migration[5.2]
  def up
    drop_table :inaccurate_resource_categories
  end

  def down
    fail ActiveRecord::IrreversibleMigration
  end
end
