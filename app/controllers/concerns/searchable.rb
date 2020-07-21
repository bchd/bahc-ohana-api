module Searchable

  def search_params(params)
    params.permit(q: [:keyword, :start_date, :end_date, :tag]).fetch(:q, {})
  end
end
