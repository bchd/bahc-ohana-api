class ReplaceLocationUrlsWithWebsite < ActiveRecord::Migration[5.1]
  def change
    add_column :locations, :website, :string
    remove_column :locations, :urls, :string
  end
end
