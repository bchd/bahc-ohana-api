namespace :import do
  task all: %i[organizations programs locations taxonomy services
               mail_addresses contacts phones regular_schedules
               holiday_schedules assign_categories reset_sequences touch_locations]

  desc 'Imports organizations'
  task :organizations, [:path] => :environment do |_, args|
    args.with_defaults(path: Rails.root.join('data', 'organizations.csv'))
    OrganizationImporter.check_and_import_file(args[:path])
  end

  desc 'Imports programs'
  task :programs, [:path] => :environment do |_, args|
    args.with_defaults(path: Rails.root.join('data', 'programs.csv'))
    ProgramImporter.check_and_import_file(args[:path])
  end

  desc 'Imports locations'
  task :locations, %i[path addresses_path] => :environment do |_, args|
    Kernel.puts("\n===> Importing locations.csv and addresses.csv")
    args.with_defaults(
      path: Rails.root.join('data', 'locations.csv'),
      addresses_path: Rails.root.join('data', 'addresses.csv')
    )
    LocationImporter.check_and_import_file(args[:path], args[:addresses_path])
  end

  desc 'Imports taxonomy'
  task :taxonomy, [:path] => :environment do |_, args|
    args.with_defaults(path: Rails.root.join('data', 'taxonomy.csv'))
    CategoryImporter.check_and_import_file(args[:path])
  end

  desc 'Imports services'
  task :services, [:path] => :environment do |_, args|
    args.with_defaults(path: Rails.root.join('data', 'services.csv'))
    ServiceImporter.check_and_import_file(args[:path])
  end

  desc 'Imports mail addresses'
  task :mail_addresses, [:path] => :environment do |_, args|
    args.with_defaults(path: Rails.root.join('data', 'mail_addresses.csv'))
    MailAddressImporter.check_and_import_file(args[:path])
  end

  desc 'Imports contacts'
  task :contacts, [:path] => :environment do |_, args|
    args.with_defaults(path: Rails.root.join('data', 'contacts.csv'))
    ContactImporter.check_and_import_file(args[:path])
  end

  desc 'Imports phones'
  task :phones, [:path] => :environment do |_, args|
    args.with_defaults(path: Rails.root.join('data', 'phones.csv'))
    PhoneImporter.check_and_import_file(args[:path])
  end

  desc 'Imports regular_schedules'
  task :regular_schedules, [:path] => :environment do |_, args|
    args.with_defaults(path: Rails.root.join('data', 'regular_schedules.csv'))
    RegularScheduleImporter.check_and_import_file(args[:path])
  end

  desc 'Imports holiday_schedules'
  task :holiday_schedules, [:path] => :environment do |_, args|
    args.with_defaults(path: Rails.root.join('data', 'holiday_schedules.csv'))
    HolidayScheduleImporter.check_and_import_file(args[:path])
  end

  desc 'Touch locations'
  task :touch_locations, [:path] => :environment do
    Kernel.puts "\n===> Updating the full-text search index"
    Location.update_all(updated_at: Time.zone.now)
  end

  # rubocop:disable Lint/HandleExceptions
  desc 'Assign OE categories to services'
  task :assign_categories, [:path] => :environment do |_, args|
    args.with_defaults(path: Rails.root.join('data', 'service_categories.json'))
    text = File.read(args[:path], encoding: 'UTF-8')
    data = JSON.parse text
    data.each_key do |service_id|
      service = Service.where(id: service_id)[0]
      next unless service

      data[service_id].each do |cat_id|
        category = Category.where(id: cat_id).first
        begin
          service.categories << category if category
        rescue ActiveRecord::RecordNotUnique
          # puts "skipping duplicate row: #{row.inspect}"
        end
      end
    end
  end

  desc 'Record original icarol categories to services'
  task :record_icarol_categories, [:path] => :environment do |_, args|
    args.with_defaults(path: Rails.root.join('data', 'service_icarol_categories.json'))
    text = File.read(args[:path], encoding: 'UTF-8')
    data = JSON.parse text
    data.each_key do |service_id|
      service = Service.where(id: service_id)[0]
      next unless service

      service.update icarol_categories: data[service_id].join(', ')
    end
  end
  # rubocop:enable Lint/HandleExceptions
end

# rubocop:disable Lint/HandleExceptions
desc 'Reset database id sequences after imports'
task :reset_sequences, [:path] => :environment do
  models = [Address, Admin, Category, Contact, HolidaySchedule, Location, MailAddress, Organization, Phone, Program, RegularSchedule, Service, User]
  models.each do |klass|
    klass.connection.reset_pk_sequence! klass.table_name
  end
end