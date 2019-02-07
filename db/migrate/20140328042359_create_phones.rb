class CreatePhones < ActiveRecord::Migration[5.1]
  def change
    create_table :phones do |t|
      t.belongs_to :location
      t.text :number
      t.text :department
      t.text :extension
      t.text :vanity_number

      t.timestamps
    end
    # add_index :phones, :location_id
  end
end
