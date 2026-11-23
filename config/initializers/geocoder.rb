# Cache lookups in Redis so repeated searches don't incur paid Google
# requests. Google's terms allow caching geocoding results for up to 30 days.
geocoder_cache = if ENV['REDIS_URL'].present?
  Redis.new(url: ENV['REDIS_URL'], ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE })
end

Geocoder.configure(
  lookup: :google,
  http_proxy: ENV['QUOTAGUARD_URL'],
  api_key: ENV['GOOGLE_MAPS_SERVER_API_KEY'],
  cache: geocoder_cache,
  cache_options: { expiration: 7.days },
  always_raise: [
    Geocoder::OverQueryLimitError,
    Geocoder::RequestDenied,
    Geocoder::InvalidRequest,
    Geocoder::InvalidApiKey
  ]
)
