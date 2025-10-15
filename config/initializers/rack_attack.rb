if ENV['ENABLE_RACK_ATTACK'] == 'true' && ENV['REDIS_URL'].present?
  Rack::Attack.cache.store = ActiveSupport::Cache::RedisCacheStore.new(url: ENV['REDIS_URL'], ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE })
  limit = ENV.fetch('IP_LIMIT', 15).to_i
  period = ENV.fetch('IP_PERIOD', 60).to_i.seconds
  Rack::Attack.throttle('req/ip', limit: limit, period: period) do |request|
    request.ip
  end
else
  Rack::Attack.enabled = false
end
