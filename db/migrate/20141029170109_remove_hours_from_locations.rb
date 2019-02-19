class RemoveHoursFromLocations < ActiveRecord::Migration[5.1]
  def change
    remove_column :locations, :hours, :text
  end
end
