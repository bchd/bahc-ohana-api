# frozen_string_literal: true

Chewy.settings = {
  host: ENV['SEARCHBOX_URL'] || 'localhost:9200',
  prefix: "bahc-ohana-api_#{Rails.env}",
  request_timeout: 240
}
