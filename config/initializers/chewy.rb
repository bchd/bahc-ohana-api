# frozen_string_literal: true

local_ealasticsearch_url = 'http://elastic:password@localhost:9200/'

# Chewy.logger = Logger.new(STDOUT) # Enable this if we want to debug

Chewy.settings = if Rails.env.test?
                   {
                     host: ENV['ELASTICSEARCH_URL'] || local_ealasticsearch_url,
                     prefix: 'test'
                   }
                 else
                   {
                     host: ENV['BONSAI_URL'] || local_ealasticsearch_url,
                     request_timeout: 240
                   }
                 end
