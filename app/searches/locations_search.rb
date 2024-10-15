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

  def distance_filter(query = index)
    return query unless distance? && lat? && long?

    d = distance.to_s + "mi"
    query.filter(geo_distance: {
      distance: d,
      coordinates: {
        lat: lat,
        lon: long
      }
    })
  end

  def distance_sort
    return unless lat? && long?

    index.order(_geo_distance: {
      coordinates: {
        lat: lat,
        lon: long
      }
    })
  end

  def order
    index.order(
      featured_at: { missing: "_last", order: "asc" },
      "_score": { "order": "desc" },
      updated_at: { order: "desc" }
    )
  end

  def tags_query
    return unless tags?

    index.query(multi_match: {
      query: tags,
      fields: %w[tags],
      analyzer: 'standard',
      fuzziness: 'AUTO'
    })
  end

  def category_filter(query = index)
    return query unless category_ids?

    query.filter(
      terms: {
        category_ids: category_ids
      }
    )
  end

  def language_filter(query = index)
    return query unless languages?

    query.filter(
      terms: {
        languages: languages
      }
    )
  end

  def accessibility_filter(query = index)
    return query unless accessibility.present?

    query.filter(
      terms: {
        accessibility: accessibility.map(&:to_s)
      }
    )
  end

  def archive_filter(query = index)
    query.filter(
      term: {
        archived: {
          value: false
        }
      }
    )
  end

  def zipcode_filter(query = index)
    return query unless zipcode?

    query.filter(match: {
      zipcode: zipcode
    })
  end

  def keyword_filter(query = index)
    return query unless keywords?

    query.query(bool: {
      should: [
        { term: { "organization_name_exact": { value: keywords.downcase, boost: 160 } } },
        { term: { "name_exact": { value: keywords.downcase, boost: 120 } } },
        { term: { "categories_exact": { value: keywords.downcase, boost: 80 } } },
        { term: { "sub_categories_exact": { value: keywords.downcase, boost: 40 } } }
      ],
      must: [{
        multi_match: {
          query: keywords,
          fields: %w[organization_name^20 name^16 categories^14 organization_tags^12 tags^10 service_tags^8 description^6 service_names^4 service_descriptions^2 keywords],
          fuzziness: 'AUTO'
        }
      }]
    })
  end

  def organization_filter(query = index)
    return query unless org_name?

    terms = org_name.downcase.split.map(&:strip)
    query.query(
      bool: {
        must: terms.map { |term|
          {
            match_phrase: {
              organization_name: {
                query: term,
                slop: 0
              }
            }
          }
        }
      }
    )
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
    filters = [
      [:archive_filter, true],
      [:organization_filter, org_name?],
      [:tags_query, tags?],
      [:category_filter, category_ids?],
      [:accessibility_filter, accessibility.present?],
      [:zipcode_filter, zipcode?],
      [:distance_filter, distance? && lat? && long?],
      [:language_filter, languages?],
      [:keyword_filter, keywords?]
    ]

    filters.each do |filter_method, condition|
      query = send(filter_method, query) if condition
    end

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
