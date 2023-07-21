Geocoder.configure({
  lookup: :google,

  google_places_search: {
    api_key: ENV.fetch("GOOGLE_PLACES_API_KEY"),
  },

  bing: {
    api_key: ENV.fetch("BING_MAPS_API_KEY"),
  },

  google: {
    api_key: ENV.fetch("GOOGLE_MAPS_API_KEY"),
  },

  cache: Rails.cache,
  ip_lookup: :ipapi_com,
  timeout: 15,
})
