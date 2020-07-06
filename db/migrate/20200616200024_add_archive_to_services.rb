class AddArchiveToServices < ActiveRecord::Migration[5.1]
  def change
    add_column :services, :archived, :boolean, default: false, null: false
    add_column :services, :archived_at, :datetime
  end
end
