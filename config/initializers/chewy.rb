# frozen_string_literal: true

elasticsearch_domain = ENV.fetch(ENV.fetch('ELASTICSEARCH_DOMAIN_PROVIDER'))
elasticsearch_port = ENV.fetch(ENV.fetch('ELASTICSEARCH_PORT_PROVIDER'))
elasticsearch_url = "#{elasticsearch_domain}:#{elasticsearch_port}"

chewy_config = {
  host: elasticsearch_url,
  logger: Rails.logger
}

Chewy.settings = chewy_config
