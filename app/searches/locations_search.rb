class LocationsSearch
  include ActiveData::Model

  PAGE = 1
  PER_PAGE = 30

  attribute :zipcode, type: String
  attribute :keywords, type: String
  attribute :org_name, type: String
  attribute :category_ids, type: Array
  attribute :tags, type: String
  attribute :archived_at, type: Date
  attribute :archived, type: Boolean
  attribute :accessibility, type: Array
  attribute :lat, type: Float
  attribute :long, type: Float
  attribute :distance, type: Integer
  
  attribute :page, type: String
  attribute :per_page, type: String


  def index
    LocationsIndex
  end

  def search
    search_results.page(fetch_page).per(fetch_per_page)
  end

  private

  def search_results
    # Order matters
    [
      organization_filter,
      archive_filter,
      keyword_filter,
      tags_query,
      zipcode_filter,
      category_filter,
      accessibility_filter, 
      distance_filter,
      distance_sort,
      order,
    ].compact.reduce(:merge)
  end

  def distance_filter
    if distance? && lat? && long?
      d = distance.to_s + "mi"

      index.filter(geo_distance: {
        distance: d,
        coordinates: {
          lat: lat,
          lon: long
        }
      })
    end
  end

  def distance_sort
    if lat? && long?
      index.order(_geo_distance: {
        coordinates: {
          lat: lat,
          lon: long
        }
      })
    end
  end

  def order
    index.order(
      featured_at: { missing: "_last", order: "asc" },
      "_score": { "order": "desc" },
      updated_at: { order: "desc" }
    )
  end

  def tags_query
    if tags?
      index.query(multi_match: {
                    query: tags,
                    fields: %w[tags],
                    analyzer: 'standard',
                    fuzziness: 'AUTO'
                  })
    end
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

  def accessibility_filter
    if accessibility?
      index.filter(
        terms: {
          accessibility: accessibility
        }
      )
    end
  end

  def archive_filter
      index.filter(
        term: {
          archived: {
            value: false
          }
        }
      )
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
      index.query(bool: {
                    should: [
                      { term: { "organization_name_exact": 
                                        { value: keywords.downcase,
                                          boost: 160
                                        }
                                      } 
                      },
                      { term: { "name_exact": 
                                        { value: keywords.downcase,
                                          boost: 120
                                        }
                                      } 
                      },
                      { term: { "categories_exact": 
                                  { value: keywords.downcase,
                                    boost: 80
                                  }
                                } 
                      },
                      { term: { "sub_categories_exact": 
                                  { value: keywords.downcase,
                                    boost: 40
                                  }
                                } 
                      }
                    ],
                    must: [
                      {
                        multi_match: {
                          query: keywords,
                          fields: %w[organization_name^20 name^16 categories^14 organization_tags^12 tags^10 service_tags^8 description^6 service_names^4 service_descriptions^2 keywords],
                          fuzziness: 'AUTO'
                        }
                      }
                    ]
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

  def fetch_page
    page.presence || PAGE
  end

  def fetch_per_page
    per_page.presence || PER_PAGE
  end
end
