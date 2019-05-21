module Searchable
  # allows a search in a collection of arrays,
  # with the field_index indicating which field to search over
  def search(collection, search_term, field_index)
    return collection if search_term.blank?

    regex = /#{search_term}/i
    collection.select! { |item| regex.match? item[field_index] }
    collection
  end

  def search_params(params)
    params.permit(:q)
  end
end
