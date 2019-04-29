desc 'Ensure that all ancestors of any category on a service are also categories on that service'
task category_ancestry: :environment do
  Service.all.each do |service|
    puts "updating ancestry for service(#{service.id}) #{service.name}"
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
