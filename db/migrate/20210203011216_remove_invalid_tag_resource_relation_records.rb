class RemoveInvalidTagResourceRelationRecords < ActiveRecord::Migration[5.2]
  def change
    execute <<-SQL
    DELETE FROM tag_resources WHERE resource_type = 'Location' AND resource_id NOT IN (SELECT id FROM locations);
    DELETE FROM tag_resources WHERE resource_type = 'Service' AND resource_id NOT IN (SELECT id FROM services);
    DELETE FROM tag_resources WHERE resource_type = 'Organization' AND resource_id NOT IN (SELECT id FROM organizations);
    SQL
  end
end
