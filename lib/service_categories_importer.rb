require 'csv'

class ServiceCategoriesImporter
  def self.check_and_import_file(path)
    ServiceCategoriesUploader.new(path).process('rake')
  end
end
