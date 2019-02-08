Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # This setting enables the use of subdomains on Heroku.
  # See config/settings.yml for more details.
#   config.action_dispatch.tld_length = ENV['TLD_LENGTH'].to_i

  # Code is not reloaded between requests.
  config.cache_classes = true

  # Eager load code on boot. This eager loads most of Rails and
  # your application in memory, allowing both threaded web servers
  # and those relying on copy on write to perform better.
  # Rake tasks automatically ignore this option for performance.
  config.eager_load = true

  # Full error reports are disabled and caching is turned on.
  config.consider_all_requests_local = false
  #may need to disable for HIPAA of requests
  # config.consider_all_requests_local = true

  # Compress JavaScripts and CSS.
  config.assets.js_compressor = :uglifier
  # config.assets.css_compressor = :sass

  # Do not fallback to assets pipeline if a precompiled asset is missed.
  config.assets.compile = false

  # Specifies the header that your server uses for sending files.
  # config.action_dispatch.x_sendfile_header = 'X-Sendfile' # for Apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for NGINX

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = (ENV['ENABLE_HTTPS'] == 'yes')
  config.force_ssl = (ENV['ENABLE_HTTPS'] == 'no')

  # Use the info log level to ensure that sensitive information
  # in SQL statements is not saved.
  config.log_level = :info

  # Prepend all log lines with the following tags.
  # config.log_tags = [ :subdomain, :uuid ]

  # Use a different logger for distributed setups.
  # config.logger = ActiveSupport::TaggedLogging.new(SyslogLogger.new)

  # --------------------------------------------------------------------------
  # CACHING SETUP FOR RACK:CACHE AND MEMCACHIER ON HEROKU
  # https://devcenter.heroku.com/articles/rack-cache-memcached-rails31
  # ------------------------------------------------------------------

  #NOT sure waht this is but I dont like it as true i think
  # config.public_file_server.enabled = true
  config.public_file_server.enabled = false

  # Asset digests allow you to set far-future HTTP expiration dates on all assets,
  # yet still be able to expire them through the digest params.
  config.assets.digest = true



  # --------------------------------------------------------------------------
  #LOTS of caching stuff. Should probs not use it // comment it out
  # # config.action_controller.perform_caching = true
  # #disable caching for HIPAA?
  # config.action_controller.perform_caching = false
  # # Specify the asset_host to prevent host header injection.
  # require 'asset_hosts'
  # config.action_controller.asset_host = AssetHosts.new
  # config.cache_store = :dalli_store
  # client = Dalli::Client.new((ENV['MEMCACHIER_SERVERS'] || '').split(','),
  #                            username: ENV['MEMCACHIER_USERNAME'],
  #                            password: ENV['MEMCACHIER_PASSWORD'],
  #                            failover: true,
  #                            socket_timeout: 1.5,
  #                            socket_failure_delay: 0.2,
  #                            value_max_bytes: 10_485_760)

  # --------------------------------------------------------------------------

  # --------------------------------------------------------------------------
  # EMAIL

   # NEed Something here but IDK what
  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.default_url_options = { host: 'lvh.me:8080' }
  config.action_mailer.delivery_method = :letter_opener

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation cannot be found).
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners.
  config.active_support.deprecation = :notify

  # Use default logging formatter so that PID and timestamp are not suppressed.
  config.log_formatter = ::Logger::Formatter.new

  # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false


  logger = ActiveSupport::Logger.new(STDOUT)
  logger.formatter = config.log_formatter
  config.logger = ActiveSupport::TaggedLogging.new(logger)
end