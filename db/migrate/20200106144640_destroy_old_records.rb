class DestroyOldRecords < ActiveRecord::Migration[5.1]
  def up
    old_locations = Location.all.select do |location|
      location.real_updated_at < Date.parse("2019-05-31")
    end

    old_locations.each do |location|
      location.address.try(:delete)
      location.contacts.try(:destroy_all)
      location.phones.try(:destroy_all)
      location.services.try(:destroy_all)
      location.regular_schedules.try(:destroy_all)
      location.holiday_schedules.try(:destroy_all)
      location.try(:delete)
    end
  end

  def down

  end
end
