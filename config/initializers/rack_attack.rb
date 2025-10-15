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

  # Be really harsh on emoji in keyword params, which is big source of issues
  Rack::Attack.blocklist('allow2ban-keyword-emoji') do |request|
    Rack::Attack::Allow2Ban.filter(request.ip, maxretry: 10, findtime: 2.minutes, bantime: 1.hour) do
      if request.params['keyword'].present? && /\p{Emoji}/ =~ request.params['keyword']
        request.ip
      end
    end
  end

  # Be harsh on long spammy keyword params, which is a big source of issues
  Rack::Attack.blocklist('allow2ban-keyword-length') do |request|
    Rack::Attack::Allow2Ban.filter(request.ip, maxretry: 10, findtime: 1.minute, bantime: 2.minutes) do
      if request.params['keyword'].to_s.length > 60
        request.ip
      end
    end
  end
else
  Rack::Attack.enabled = false
end
