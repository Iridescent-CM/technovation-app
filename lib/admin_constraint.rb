class AdminConstraint
  def matches?(request)
    auth_token = request.cookie_jar.signed[CookieNames::AUTH_TOKEN]
    return false if auth_token.blank?

    Account.joins(:admin_profile)
      .where(deactivated_at: nil)
      .exists?(auth_token: auth_token)
  end
end
