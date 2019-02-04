class RenameOeIdToTaxonomyId < ActiveRecord::Migration[5.1]
  def change
    rename_column :categories, :oe_id, :taxonomy_id
  end
end
