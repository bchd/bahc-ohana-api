class LocationsSearch
  include ActiveData::Model

  attribute :zipcode, type: String
  attribute :keywords, type: String
  attribute :org_name, type: String

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
      zipcode_filter
    ].compact.reduce(:merge)
  end

  def zipcode_filter
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
                     fields: %w[name description keywords]
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
