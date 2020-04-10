# frozen_string_literal: true

Chewy.settings = {
  host: ENV['BONSAI_URL'] || 'localhost:9200',
  request_timeout: 240
}
