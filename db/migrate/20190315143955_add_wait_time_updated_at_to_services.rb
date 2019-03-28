class AddWaitTimeUpdatedAtToServices < ActiveRecord::Migration[5.1]
  def change
    add_column :services, :wait_time_updated_at, :timestamp
  end
end
