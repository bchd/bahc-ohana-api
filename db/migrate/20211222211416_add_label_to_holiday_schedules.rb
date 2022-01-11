class AddLabelToHolidaySchedules < ActiveRecord::Migration[5.2]
  def change
    add_column :holiday_schedules, :label, :string
  end
end
