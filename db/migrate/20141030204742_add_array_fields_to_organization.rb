class AddArrayFieldsToOrganization < ActiveRecord::Migration[5.1]
  def change
    add_column :organizations, :funding_sources, :string, array: true, default: []
    add_column :organizations, :accreditations, :string, array: true, default: []
    add_column :organizations, :licenses, :string, array: true, default: []
  end
end
