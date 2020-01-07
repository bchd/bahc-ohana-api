class DestroyOldRecords < ActiveRecord::Migration[5.1]
  def change
    old_locations = Location.all.select do |location|
      location.updated_at < Date.parse("2019-05-30")
    end

    old_locations.each do |location|
      location.address.delete
      location.contacts.destroy_all
      location.phones.destroy_all
      location.services.destroy_all
      location.regular_schedules.destroy_all
      location.holiday_schedules.destroy_all
      location.delete
    end
  end
end
