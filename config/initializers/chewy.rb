# frozen_string_literal: true

Chewy.settings = {
  host: ENV['SEARCHBOX_URL'] || 'localhost:9200',
  request_timeout: 240
}
