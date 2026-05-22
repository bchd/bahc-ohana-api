if ENV['SENTRY_DSN'].present?
  Sentry.init do |config|
    config.dsn = ENV['SENTRY_DSN']
    config.environment = ENV['SENTRY_ENV'] || Rails.env
    config.enabled_environments = %w[production staging dev]
  end
end
