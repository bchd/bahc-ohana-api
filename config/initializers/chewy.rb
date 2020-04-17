# frozen_string_literal: true

Chewy.settings = if Rails.env.test?
                   {
                     host: 'localhost:9200',
                     prefix: 'test'
                   }
                 else
                   {
                     host: ENV['BONSAI_URL'] || 'localhost:9200',
                     request_timeout: 240
                   }
                 end
