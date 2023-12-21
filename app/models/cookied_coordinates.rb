class CookiedCoordinates
  def self.get(cookie_jar)
    if cookie = cookie_jar.get_cookie(CookieNames::IP_GEOLOCATION)
      cookie["coordinates"]
    end
  end
end
