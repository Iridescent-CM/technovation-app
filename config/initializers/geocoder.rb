Geocoder.configure({
  lookup: :bing,
  api_key: ENV.fetch("BING_GEOCODER_KEY"),
  cache: Rails.cache,
  timeout: 15,
})
