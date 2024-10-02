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
  attribute :languages, type: Array

  attribute :page, type: String
  attribute :per_page, type: String

  attribute :matched_category, type: Object

  def index
    LocationsIndex
  end

  def search
    query = LocationsIndex.query(build_query)
    query = apply_filters(query)
    query = apply_sorting(query)
    search_results = query.page(fetch_page).per(fetch_per_page)
    search_results
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
      language_filter,
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

  def language_filter
    if languages?
      index.filter(
        terms: {
          languages: languages
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
    else
      index
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

  def build_query
    if matched_category.is_a?(Category)
      {
        bool: {
          should: [
            { term: { category_ids: matched_category.id } },
            { term: { "categories_exact": matched_category.name.downcase } }
          ]
        }
      }
    elsif keywords.present?
      { multi_match: { query: keywords, fields: %w[organization_name^20 name^16 categories^14 organization_tags^12 tags^10 service_tags^8 description^6 service_names^4 service_descriptions^2 keywords], fuzziness: 'AUTO' } }
    else
      { match_all: {} }
    end
  end

  def apply_filters(query)
    query = query.filter(term: { archived: false })
    query = apply_category_filter(query) if category_ids.present?
    query
  end

  def apply_keyword_filter(query)
    query.query(multi_match: {
      query: keywords,
      fields: %w[organization_name^20 name^16 categories^14 organization_tags^12 tags^10 service_tags^8 description^6 service_names^4 service_descriptions^2 keywords],
      fuzziness: 'AUTO'
    })
  end

  def apply_category_filter(query)
    query.filter(terms: { category_ids: category_ids })
  end

  def apply_sorting(query)
    query.order(
      featured_at: { missing: "_last", order: "asc" },
      "_score": { "order": "desc" },
      updated_at: { order: "desc" }
    )
  end
end
