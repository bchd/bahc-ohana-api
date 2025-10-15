if ENV['ENABLE_RACK_ATTACK'] == 'true' && ENV['REDIS_URL'].present?
  Rack::Attack.cache.store = ActiveSupport::Cache::RedisCacheStore.new(url: ENV['REDIS_URL'], ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE })

  # Focus on the /location paths
  limit = ENV.fetch('IP_LIMIT', 30).to_i
  period = ENV.fetch('IP_PERIOD', 120).to_i.seconds
  Rack::Attack.throttle('req/ip', limit: limit, period: period) do |request|
    if /\/location/ =~ request.path
      request.ip
    end
  end

  # Be really harsh on emoji in keyword params, which is the biggest source of issues
  Rack::Attack.throttle('req/keyword-emoji/ip', limit: 10, period: 5.minutes) do |request|
    if request.params['keyword'].present? && /\p{Emoji}/ =~ request.params['keyword']
      request.ip
    end
  end
else
  Rack::Attack.enabled = false
end
