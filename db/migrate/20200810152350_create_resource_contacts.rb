class CreateResourceContacts < ActiveRecord::Migration[5.2]
  def change
    create_table :resource_contacts do |t|
      t.bigint :contact_id, null: false
      t.bigint :resource_id, null: false
      t.string :resource_type, null: false

      t.timestamps
    end

    add_index :resource_contacts, [:contact_id, :resource_id, :resource_type], :name => 'index_resource_contacts_on_cntct_id_and_rsrc_id_and_rsrc_type'
    add_index :resource_contacts, [:resource_id, :resource_type]
  end
end