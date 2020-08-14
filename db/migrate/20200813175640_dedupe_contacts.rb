class DedupeContacts < ActiveRecord::Migration[5.2]
  def up
    results = ActiveRecord::Base.connection.execute("
      select name, id, title, email, updated_at from contacts where name in (select name from contacts group by name having (count(*) > 1)) order by name;
    ").to_a
    contacts_by_name = results.group_by { |contact| [ contact['name'], (contact['email'] || "").downcase ]}
    contacts_by_name.map do |_, contacts|
      contact = contacts.sort_by(:updated_at)
      # contact = contacts.shift
      
    end
  
  end

  def down
  
  end
end
