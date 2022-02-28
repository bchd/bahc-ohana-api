class AddFavorites < ActiveRecord::Migration[5.1]
  def change
    create_table :favorites do |t|
      t.string :url
      t.string :name
      t.string :resource_type
      t.integer :resource_id
      t.references :user
    end
  end
end
