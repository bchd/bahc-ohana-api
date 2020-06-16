class AddReportJsonbColumnToFlags < ActiveRecord::Migration[5.1]
  def change
    add_column :flags, :report, :jsonb, default: {}
    add_index :flags, :report, using: :gin
  end
end
