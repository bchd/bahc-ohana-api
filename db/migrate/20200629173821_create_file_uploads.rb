class CreateFileUploads < ActiveRecord::Migration[5.1]
  def change
    create_table :file_uploads do |t|
      t.references(:location, foreign_key: true)
      t.string :file_name
      t.text :file_data
    end
  end
end
