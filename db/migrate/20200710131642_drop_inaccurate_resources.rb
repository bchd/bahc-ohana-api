class DropInaccurateResources < ActiveRecord::Migration[5.2]
  def up
    drop_table :inaccurate_resources
  end

  def down
    fail ActiveRecord::IrreversibleMigration
  end
end
