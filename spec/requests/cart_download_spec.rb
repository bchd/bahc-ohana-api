require 'rails_helper'

describe 'GET /cart/download' do
  let(:location) { create(:location) }

  context 'with listings selected in the cart cookie' do
    before do
      cookies[:pdf_cart] = [location.id].to_json
      get '/cart/download'
    end

    it 'returns a 200 HTTP status' do
      expect(response).to have_http_status(200)
    end

    it 'returns a PDF' do
      expect(response.content_type).to start_with('application/pdf')
      expect(response.body).to start_with('%PDF')
    end

    it 'serves the PDF as an attachment' do
      expect(response.headers['Content-Disposition']).
        to include('attachment', 'selected-services.pdf')
    end

    it 'clears the cart cookie so the selection is not downloaded twice' do
      expect(response.cookies['pdf_cart']).to be_blank
    end
  end

  context 'when the cart is empty' do
    before { get '/cart/download' }

    it 'still returns a valid PDF' do
      expect(response).to have_http_status(200)
      expect(response.body).to start_with('%PDF')
    end
  end

  context 'when the cart cookie contains non-numeric values' do
    before do
      cookies[:pdf_cart] = ['1 OR 1=1', 'abc'].to_json
      get '/cart/download'
    end

    it 'ignores them and returns a valid PDF' do
      expect(response).to have_http_status(200)
      expect(response.body).to start_with('%PDF')
    end
  end
end
