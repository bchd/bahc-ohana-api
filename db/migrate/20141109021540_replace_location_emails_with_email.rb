class ReplaceLocationEmailsWithEmail < ActiveRecord::Migration[5.1]
  def change
    add_column :locations, :email, :string
    remove_column :locations, :emails, :text
  end
end
