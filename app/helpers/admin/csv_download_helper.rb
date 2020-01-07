class Admin
  module CsvDownloadHelper
    def csv_tables
      %w[addresses categories contacts holiday_schedules locations
         organizations phones regular_schedules services]
    end
  end
end
