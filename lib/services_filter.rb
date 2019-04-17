require 'exceptions'

class ServicesFilter
  class << self
    delegate :call, to: :new
  end

  def initialize(model_class = Location)
    @model_class = model_class
  end

  def call(category_ids)
    if category_ids.blank? || category_ids.empty?
      @model_class.all
    else
      @model_class.where(id: filter_by_categories(category_ids))
    end
  end

  private

  def filter_by_categories(category_ids)
    locations = @model_class.select do |location|
      location.services.select do |service|
        service_has_categories(service, category_ids)
      end.any?
    end
    locations.map(&:id)
  end

  def service_has_categories(service, category_ids)
    results_cats = service.categories.map{ |c| c.id.to_s }
    (category_ids - results_cats).empty?
  end
end
