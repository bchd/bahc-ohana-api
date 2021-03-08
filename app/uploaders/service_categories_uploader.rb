class ServiceCategoriesUploader
  class ServiceCategoriesUploadError < StandardError
  end

  def initialize(file_path)
    @file_path = file_path
  end

  def process(src)
    puts "processing #{@file_path.path.to_s.split('/').last}"
    csv = SmarterCSV.process(@file_path)

    if src == 'admin' && csv.count > 100
      raise ServiceCategoriesUploadError, "Service Categories CSV must have 100 rows or fewer."
    end


    csv.each do |attributes|
      new_parent_string = attributes[:new_category]
      clear_string = attributes[:clear_categories]
      clear = clear_string.to_s.downcase == 'clear'
      next if new_parent_string.blank? && !clear

      # Find service and raise if it's not found
      service = Service.find_by(id: attributes[:id])

      if service.present?

        # If there is a new category set find and set the category, otherwise create it.
        if new_parent_string.present?
          puts "Updating categories for service: #{service.name}"

          new_categories = []
          category = Category.find_or_create_by(name: new_parent_string)
          new_categories << category

          # same deal for the subcategory
          subcategory_string = attributes[:new_subcategory]
          if subcategory_string.present?
            subcategory = category.children.find_or_create_by(name: subcategory_string)
            new_categories << subcategory
          end

          service.categories = new_categories
        end

        # Clearing the categories clears the categories no matter what
        if clear
          service.categories = []
        end
      end
    end
  end
end
