class AdminConstraint
  def matches?(request)
    request.cookie_jar.signed[CookieNames::AUTH_TOKEN] and
      Account.joins(:admin_profile).exists?(auth_token: request.cookie_jar.signed[CookieNames::AUTH_TOKEN])
  end
end
