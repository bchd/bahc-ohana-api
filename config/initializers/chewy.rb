# frozen_string_literal: true

local_ealasticsearch_url = 'localhost:9200'

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
