require 'exceptions'

class ServicesFilter
  class << self
    delegate :call, to: :new
  end

  def initialize(model_class = Location)
    @model_class = model_class
  end

  def call(services_params)
    byebug
    if services_params.blank? || services_params.empty?
      @model_class.all
    else
      @model_class.where(id: filter_by_categories(services_params))
    end
  end

  private

  def filter_by_categories(services_params)
    locations = @model_class.select do |location|
      location.services.select do |service|
        services_with_categories(service, services_params).any?
      end.any?
    end
    locations.map(&:id)
  end

  def services_with_categories(service, category_ids)
    cat_ids = []
    category_ids.each do |id|
      cat_ids.push(id.to_i)
    end
    service.categories.select { |category| cat_ids.include?(category.id) }
  end
end
