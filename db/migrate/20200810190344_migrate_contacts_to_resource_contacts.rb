class MigrateContactsToResourceContacts < ActiveRecord::Migration[5.2]
  def up
    execute <<-SQL
     insert into resource_contacts (contact_id, resource_id, resource_type, created_at, updated_at)
      select
        id as contact_id,
        organization_id as resource_id,
        'Organization' as resource_type,
        now() as created_at,
        now() as updated_at
      from contacts
      where organization_id is not null;
    SQL

    execute <<-SQL
     insert into resource_contacts (contact_id, resource_id, resource_type, created_at, updated_at)
      select
        id as contact_id,
        location_id as resource_id,
        'Location' as resource_type,
        now() as created_at,
        now() as updated_at
      from contacts
      where location_id is not null;
    SQL

    execute <<-SQL
     insert into resource_contacts (contact_id, resource_id, resource_type, created_at, updated_at)
      select
        id as contact_id,
        service_id as resource_id,
        'Service' as resource_type,
        now() as created_at,
        now() as updated_at
      from contacts
      where service_id is not null;
   SQL
  end

  def down
    execute("truncate resource_contacts")
  end
end
