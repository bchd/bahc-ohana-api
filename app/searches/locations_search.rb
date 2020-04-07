class LocationsSearch
  include ActiveData::Model

  attribute :zipcode, type: String
  attribute :keywords, type: String

  def index
    LocationsIndex
  end

  def search
    search_results
  end

  private

  def search_results
    # Order matters
    keyword_filter
    maybe_sort_by_zipcode
  end

  def maybe_sort_by_zipcode
    results = keyword_filter

    if zipcode.present?
      results = []
      keyword_filter[zipcode].each{|l| results << l} unless keyword_filter[zipcode].blank?
      hash_without_zipcode = keyword_filter.tap{|h| h.delete(zipcode)}
      hash_without_zipcode.keys.each do |key|
        hash_without_zipcode[key].each {|l| results << l}
      end

      results
    else
      results.values.flatten
    end
  end

  def keyword_filter
    index.filter(multi_match:{
      query: keywords,
      fields: ['name', 'description', 'keywords']
    }).load.objects.group_by{|l| l.address.postal_code}
  end
end
