class AddSearchIndexToOrganizations < ActiveRecord::Migration[5.1]
  def up
    execute "create index organizations_name on organizations using gin(to_tsvector('english', name))"
  end

  def down
    execute "drop index organizations_name"
  end
end
