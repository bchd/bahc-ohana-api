require 'rails_helper'

describe 'GET /cart/preview' do
  context 'when the locations page passed its search and filter params along' do
    # NB: spec/support/default_headers.rb overrides `get` to take its params
    # positionally, so they can't be passed as `params:` here.
    before do
      get '/cart/preview',
          keyword: 'food',
          main_category: 'Food',
          categories: %w[Groceries Meals],
          distance: '5',
          address: '21201'
    end

    it 'returns a 200 HTTP status' do
      expect(response).to have_http_status(200)
    end

    it 'points the "Go back" link at the same search' do
      href = back_link_href

      expect(href).to start_with('/locations?')
      expect(query_params_of(href)).to include(
        'keyword' => 'food',
        'main_category' => 'Food',
        'categories' => %w[Groceries Meals],
        'distance' => '5',
        'address' => '21201'
      )
    end

    it 'marks the return trip so it is not counted as a new search' do
      expect(query_params_of(back_link_href)).to include('back_navigation' => 'true')
    end

    it 'asks for the full results page rather than the AJAX partial' do
      expect(query_params_of(back_link_href)).to include('layout' => 'true')
    end

    it 'points the breadcrumb at the same search' do
      breadcrumb = page_body.css('#breadcrumb a').last

      expect(breadcrumb.text).to eq('Community Resources')
      expect(breadcrumb[:href]).to eq(back_link_href)
    end
  end

  context 'when there were no search params to preserve' do
    before { get '/cart/preview' }

    it 'still links back to the results page' do
      expect(back_link_href).to start_with('/locations')
    end
  end

  def page_body
    Nokogiri::HTML(response.body)
  end

  def back_link_href
    page_body.at_css('.cart-preview__back')[:href]
  end

  def query_params_of(href)
    Rack::Utils.parse_nested_query(URI.parse(href).query)
  end
end
