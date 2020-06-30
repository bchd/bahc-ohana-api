class AddAchiveStatusToLocations < ActiveRecord::Migration[5.1]
  def change
    add_column :locations, :archived_at, :datetime, default: nil
  end
end
