class AddAudienceToLocations < ActiveRecord::Migration[5.2]
  def change
    add_column :locations, :audience, :string
  end
end
