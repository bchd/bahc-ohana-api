class CartController < ApplicationController
  # Renders a preview of the listings the user selected via the "Add to PDF"
  # cart before they download a PDF. The selection lives client-side in the
  # `pdf_cart` cookie (see app/javascript/app/cart/pdf-cart.js); we read it here
  # and load the matching locations, preserving the order they were added.
  def preview
    ids = selected_location_ids

    locations = ids.present? ? load_locations(ids) : []
    @locations = ids.map { |id| locations.find { |l| l.id.to_s == id } }.compact
  end

  private

  # The selected location IDs from the cart cookie, as an array of strings.
  # The cookie holds a JSON array of IDs, URL-encoded by the client; Rack
  # usually decodes it for us, but we fall back to manual unescaping to be safe.
  # Non-numeric values are dropped so they can never reach the query.
  def selected_location_ids
    raw = cookies[:pdf_cart]
    return [] if raw.blank?

    parsed = parse_cart_cookie(raw)
    return [] unless parsed.is_a?(Array)

    parsed.map(&:to_s).select { |id| id.match?(/\A\d+\z/) }
  end

  def parse_cart_cookie(raw)
    JSON.parse(raw)
  rescue JSON::ParserError
    begin
      JSON.parse(CGI.unescape(raw))
    rescue JSON::ParserError
      []
    end
  end

  def load_locations(ids)
    Location
      .where(id: ids)
      .includes(:organization, :phones, services: :categories)
  end
end
