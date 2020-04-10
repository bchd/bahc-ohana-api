class CreateFlags < ActiveRecord::Migration[5.1]
  def change
    create_table :flags do |t|
      t.belongs_to :organization, class_name: "organization", foreign_key: "organization_id"
      t.text :reported_by_email
      t.text :description

      t.text :category
      t.timestamps
    end
  end
end
