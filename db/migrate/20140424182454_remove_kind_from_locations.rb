class RemoveKindFromLocations < ActiveRecord::Migration[5.1]
  def change
    remove_column :locations, :kind, :text
  end
end
