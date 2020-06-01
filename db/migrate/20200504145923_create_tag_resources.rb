class CreateTagResources < ActiveRecord::Migration[5.1]
  def change
    create_table :tag_resources do |t|
      t.bigint :tag_id, null: false
      t.bigint :resource_id, null: false
      t.string :resource_type, null: false

      t.timestamps
    end

    add_index :tag_resources, [:tag_id, :resource_id, :resource_type]
    add_index :tag_resources, [:resource_id, :resource_type]
  end
end
