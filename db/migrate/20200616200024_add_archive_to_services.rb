class AddArchiveToServices < ActiveRecord::Migration[5.1]
  def change
    add_column :services, :archived_at, :datetime, default: nil
  end
end
