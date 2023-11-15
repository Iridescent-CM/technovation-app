module CookieNames
  AUTH_TOKEN                      = [ENV.fetch("COOKIES_AUTH_TOKEN"), Season.current.year].join("_")
  LAST_PROFILE_USED               = ENV.fetch("COOKIES_LAST_PROFILE_USED")
  LAST_VISITED_SUBMISSION_SECTION = ENV.fetch("COOKIES_LAST_VISITED_SUBMISSION_SECTION")
  IP_GEOLOCATION                  = ENV.fetch("COOKIES_IP_GEOLOCATION")
  REDIRECTED_FROM                 = ENV.fetch("COOKIES_REDIRECTED_FROM")
  SESSION_TOKEN                   = ENV.fetch("COOKIES_SESSION_TOKEN")
end
