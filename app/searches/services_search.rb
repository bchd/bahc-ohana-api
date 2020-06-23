class ServicesSearch
  include ActiveData::Model

  PAGE = 1
  PER_PAGE = 30

  attribute :tags, type: String
  attribute :page, type: String
  attribute :archived_at, type: Date
  attribute :archived, type: Boolean

  attribute :per_page, type: String

  def index
    ServicesIndex
  end

  def search
    search_results.page(fetch_page).per(fetch_per_page)
  end

  private

  def search_results
    # Order matters
    [
      # archive_filter,
      tags_query,
    ].compact.reduce(:merge)
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
  
  # def archive_filter
  #   index.filter(
  #       term: {
  #         archived: {
  #           value: false
  #         }
  #       }
  #     )
  # end

  def fetch_page
    page.presence || PAGE
  end

  def fetch_per_page
    per_page.presence || PER_PAGE
  end
end
