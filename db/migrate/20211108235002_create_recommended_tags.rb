class CreateRecommendedTags < ActiveRecord::Migration[5.2]
  def change
    create_table :recommended_tags do |t|
      t.string :name, null: false
      t.boolean :active, default: true, null: false

      t.timestamps
    end
  end
end
