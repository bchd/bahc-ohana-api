namespace :import do
  task all: %i[organizations programs locations taxonomy services
               contacts phones regular_schedules
               holiday_schedules assign_categories category_ancestry
               reset_sequences touch_locations]

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
    print '===> destroying all existing categories'
    Category.destroy_all
    puts '  done.'
    Category.connection.reset_pk_sequence! Category.table_name
    args.with_defaults(path: Rails.root.join('data', 'taxonomy.csv'))
    CategoryImporter.check_and_import_file(args[:path])
    puts '----yay'
    Category.connection.reset_pk_sequence! Category.table_name
  end

  desc 'Imports services'
  task :services, [:path] => :environment do |_, args|
    args.with_defaults(path: Rails.root.join('data', 'services.csv'))
    ServiceImporter.check_and_import_file(args[:path])
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
    puts '===> assign categories to services'
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

  desc 'Ensure that ancestors of any category on a service are also categories on that service'
  task category_ancestry: :environment do
    puts '===> update category ancestries'
    Service.all.each do |service|
      puts "  updating ancestry for service(#{service.id}) #{service.name}"
      service_categories = service.categories
      ancestry = service_categories&.map(&:ancestry)
      next unless ancestry.present?
      ancestor_ids = ancestry.map { |a| a&.split('/')&.map(&:to_i) }&.
        flatten&.
        delete_if(&:nil?)&.
        sort
      next unless ancestor_ids
      missing_ancestor_ids = ancestor_ids - service_categories.map(&:id)
      missing_ancestors = Category.where(id: missing_ancestor_ids)
      service.categories << missing_ancestors
    end
  end

  desc 'Record original icarol categories to services'
  task :record_icarol_categories, [:path] => :environment do |_, args|
    puts '===> record iCarol categories'
    args.with_defaults(path: Rails.root.join('data', 'icarol-csv/service_icarol_categories.json'))
    text = File.read(args[:path], encoding: 'UTF-8')
    data = JSON.parse text
    data.each_key do |service_id|
      service = Service.where(id: service_id)[0]
      next unless service

      service.update icarol_categories: data[service_id].join(', ')
    end
  end
  # rubocop:enable Lint/HandleExceptions

  # rubocop:disable Metrics/LineLength
  desc 'Reset database id sequences after imports'
  task :reset_sequences, [:path] => :environment do
    puts '===> reset database id sequences'
    models = [Address, Admin, Category, Contact, HolidaySchedule, Location, MailAddress, Organization, Phone, Program, RegularSchedule, Service, User]
    models.each do |klass|
      klass.connection.reset_pk_sequence! klass.table_name
    end
  end
  # rubocop:enable Metrics/LineLength
end
