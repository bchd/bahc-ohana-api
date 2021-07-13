class AddsCompletedAtToFlags < ActiveRecord::Migration[5.2]
  def change
    add_column :flags, :completed_at, :datetime, default: nil
  end
end
