class Admin
  module CsvDownloadHelper
    def csv_tables
      %w[addresses categories contacts covid_19_locations food_and_covid_services holiday_schedules locations
         organizations phones regular_schedules services service_categories]
    end
  end
end
