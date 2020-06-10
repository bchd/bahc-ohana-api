class AddFeaturedAtColumnToLocation < ActiveRecord::Migration[5.1]
  def change
    add_column :locations, :featured_at, :timestamp
  end
end
