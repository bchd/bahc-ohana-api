class LocationsSearch
  include ActiveData::Model

  attribute :zipcode, type: String
  attribute :keywords, type: String
  attribute :org_name, type: String
  attribute :category_ids, type: Array

  def index
    LocationsIndex
  end

  def search
    search_results
  end

  private

  def search_results
    # Order matters
    [
      organization_filter,
      keyword_filter,
      zipcode_filter,
      category_filter
    ].compact.reduce(:merge)
  end

  def category_filter
    if category_ids?
      index.filter(
        terms: {
          category_ids: category_ids
        }
      )
    end
  end

  def zipcode_filter
    # NOTE: I think we also need to consider location's coordinates and its radius.
    # Because some of our specs are using these scenarios too.

    if zipcode?
      index.filter(match: {
                     zipcode: zipcode
                   })
    end
  end

  def keyword_filter
    if keywords?
      index.filter(multi_match: {
                     query: keywords,
                     fields: %w[name description keywords organization_name]
                   })
    end
  end

  def organization_filter
    if org_name?
      index.filter(match_phrase: {
                     organization_name: org_name
                   })
    end
  end
end
