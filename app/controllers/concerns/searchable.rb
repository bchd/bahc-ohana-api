module Searchable
  # allows a search in a collection of arrays,
  # with the field_index indicating which field to search over

  def search(collection, search_terms, field_index)
    regex = /#{search_terms}/i
    collection.select! { |item| regex.match? item[field_index] }
    collection
  end

  def search_params(params)
    params.permit(q: [:keyword, :start_date, :end_date, :tag]).fetch(:q, {})
  end
end
