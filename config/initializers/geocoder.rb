Geocoder.configure(
  lookup: :google,
  http_proxy: ENV['QUOTAGUARD_URL'],
  api_key: ENV['GOOGLE_MAPS_SERVER_API_KEY'],
  always_raise: [
    Geocoder::OverQueryLimitError,
    Geocoder::RequestDenied,
    Geocoder::InvalidRequest,
    Geocoder::InvalidApiKey
  ]
)
