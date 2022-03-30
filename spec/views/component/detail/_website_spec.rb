require 'rails_helper'

RSpec.describe 'component/detail/website' do
  let(:website_regex) { %r{<a href='#{test_website}'.*>\n#{test_website.split('/')[2]}\n</a>} }

  before do
    render 'component/detail/website', website: test_website, show_phone_type_and_department: true
  end

  context 'when contains https://' do
    let(:test_website) { 'https://www.smctest.org' }

    it 'will reformat the link correctly' do
      expect(response).to match(website_regex)
    end
  end

  context 'when contains http://' do
    let(:test_website) { 'http://www.smctest.org' }

    it 'will reformat the link correctly' do
      expect(response).to match(website_regex)
    end
  end

  context 'when does not contain http:// or https://' do
    let(:test_website) { 'www.smctest.org' }
    let(:website_regex) { %r{<a href='#{test_website}'.*>\n#{test_website}\n</a>} }

    it 'will reformat the link correctly' do
      expect(response).to match(website_regex)
    end
  end

  context 'when malformed' do
    let(:test_website) { 'http:/www.smctest.org' }
    let(:website_regex) { %r{<a href='#{test_website}'.*>\n#{test_website}\n</a>} }

    it 'will reformat the link correctly' do
      expect(response).to match(website_regex)
    end
  end
end
