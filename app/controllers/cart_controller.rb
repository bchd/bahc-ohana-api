class CartController < ApplicationController
  include PhoneFormatHelper
  include AddressFormatHelper

  # Renders a preview of the listings the user selected via the "Add to PDF"
  # cart before they download a PDF. The selection lives client-side in the
  # `pdf_cart` cookie (see app/javascript/app/cart/pdf-cart.js); we read it here
  # and load the matching locations, preserving the order they were added.
  def preview
    @locations = cart_locations
    @back_to_results_params = back_to_results_params
  end

  # Streams the selected listings as a PDF (name, phone, link and address per
  # listing) and clears the cart cookie so the selection isn't downloaded twice.
  def download
    listings = cart_locations.map { |location| pdf_listing_for(location) }
    pdf = CartPdf.new(listings).render
    cookies.delete(:pdf_cart)

    send_data pdf,
              filename: 'selected-services.pdf',
              type: 'application/pdf',
              disposition: 'attachment'
  end

  private

  # The params the "Go back" link needs to return the user to the search results
  # they came from, with their search and filter selections intact. The locations
  # page hands them to us on the preview URL (see
  # app/javascript/app/cart/pdf-cart.js), the same way a location detail page
  # carries them for its own back link.
  #
  # `layout` guards against going back to the layout-less partial the results
  # page renders for AJAX filtering, and `back_navigation` keeps the return trip
  # from being recorded as a brand new search.
  def back_to_results_params
    request.query_parameters.merge('layout' => true, 'back_navigation' => true)
  end

  # The selected locations, ordered as they were added to the cart.
  def cart_locations
    ids = selected_location_ids
    locations = ids.present? ? load_locations(ids) : []
    ids.map { |id| locations.find { |l| l.id.to_s == id } }.compact
  end

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
      .includes(:organization, :address, :phones, services: :categories)
  end

  # The fields the PDF needs for a single listing, formatted with the same
  # helpers the HTML views use so the values match what the user saw.
  def pdf_listing_for(location)
    phone = first_voice_or_hotline_phone_for(location.phones)

    {
      name: listing_name_for(location),
      phone: phone && format_phone(phone.number),
      link: listing_link_for(location),
      address: location.address && full_address_for(location.address)
    }
  end

  # Plain-text name (with the alternate name in parentheses, when present).
  def listing_name_for(location)
    return location.name if location.alternate_name.blank?

    "#{location.name} (#{location.alternate_name})"
  end

  # Absolute URL to the location's public detail page. Mirrors
  # ResultSummaryHelper#location_link_for but returns a full URL for the PDF.
  def listing_link_for(location)
    if location.organization.name == location.name
      location_url([location.slug])
    else
      location_url([location.organization.slug, location.slug])
    end
  end
end
