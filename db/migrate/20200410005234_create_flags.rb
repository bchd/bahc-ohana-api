class CreateFlags < ActiveRecord::Migration[5.1]
  def up
    create_table :flags do |t|
      t.bigint :resource_id
      t.string :resource_type
      t.string :email
      t.text :description

      t.timestamps
    end
  end

  def down
    drop_table :flags
  end
end
