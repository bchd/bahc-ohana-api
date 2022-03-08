class RemoveApiApplications < ActiveRecord::Migration[5.2]
  def change
    drop_table :api_applications
  end
end
