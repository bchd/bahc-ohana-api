class UpdateFileUpload < ActiveRecord::Migration[5.2]
  def change
    rename_column :file_uploads, :file_data, :image_data
  end
end
