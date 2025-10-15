if ENV['ENABLE_RACK_ATTACK'] == 'true' && ENV['REDIS_URL'].present?
  Rack::Attack.cache.store = ActiveSupport::Cache::RedisCacheStore.new(url: ENV['REDIS_URL'])
  Rack::Attack.throttle("requests by ip", limit: 6, period: 30) do |request|
    request.ip
  end
else
  Rack::Attack.enabled = false
end
