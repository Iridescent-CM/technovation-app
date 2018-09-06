class CookiedCoordinates
  def self.get(cookie_jar)
    cookie_jar.get_cookie(CookieNames::IP_GEOLOCATION)['coordinates']
  end
end