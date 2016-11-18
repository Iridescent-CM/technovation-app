class AdminConstraint
  def matches?(request)
    request.cookie_jar['auth_token'] and
      Account.joins(:admin_profile).exists?(auth_token: request.cookie_jar['auth_token'])
  end
end
