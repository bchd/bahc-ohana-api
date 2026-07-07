require 'prawn'

# Builds the PDF a user downloads from the cart preview page (/cart/preview).
# It receives the listings as plain hashes so all formatting (phone, address,
# absolute link) stays in the controller where the Rails helpers live; this
# class only concerns itself with laying the values out on the page.
#
# Each listing hash may contain: :name, :phone, :link, :address.
class CartPdf
  HEADING = 'Selected services'.freeze

  # @param listings [Array<Hash>] The listings to render, in display order.
  def initialize(listings)
    @listings = listings
  end

  # @return [String] The rendered PDF as a binary string.
  def render
    document.text HEADING, size: 22, style: :bold
    document.move_down 18

    @listings.each_with_index do |listing, index|
      render_listing(listing, index + 1)
    end

    document.render
  end

  private

  def document
    @document ||= Prawn::Document.new(page_size: 'LETTER', margin: 50)
  end

  def render_listing(listing, position)
    document.text "#{position}. #{listing[:name]}", size: 14, style: :bold
    document.move_down 4

    render_field('Phone', listing[:phone])
    render_field('Address', listing[:address])
    render_field('Link', listing[:link])

    document.move_down 18
  end

  # Renders one "Label: value" line, skipping fields the listing is missing.
  def render_field(label, value)
    return if value.blank?

    document.text "#{label}: #{value}", size: 11
    document.move_down 2
  end
end
