class RenameWaitToWaitTime < ActiveRecord::Migration[5.1]
  def change
    rename_column :services, :wait, :wait_time
  end
end
