class AdminsSearch
  include ActiveData::Model

  PAGE = 1
  PER_PAGE = 30

  attribute :super_admin, type: Boolean
  attribute :search_keywords, type: String

  attribute :page, type: String
  attribute :per_page, type: String

  def index
    AdminsIndex
  end

  def search
    search_results.page(fetch_page).per(fetch_per_page)
  end

  private

  def search_results
    # Order matters
    [
      super_admin_filter,
      search_query,
      order,
    ].compact.reduce(:merge)
  end

  def order
    index.order(
      domain: { order: "asc" },
      email: { order: "asc" }
    )
  end

  def super_admin_filter
    unless super_admin.nil?
      index.filter(term: { super_admin: super_admin })
    end
  end

  def search_query
    if search_keywords?
      index.query(multi_match: {
                    query: search_keywords,
                    fields: %w[name email],
                    analyzer: 'standard',
                    fuzziness: 'AUTO'
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
