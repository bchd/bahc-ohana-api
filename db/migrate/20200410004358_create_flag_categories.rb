class CreateFlagCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :flag_categories do |t|
      t.text :name

      t.timestamps
    end
  end
end
