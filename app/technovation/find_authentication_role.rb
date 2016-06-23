module FindAuthenticationRole
  def self.authenticated?(cookies)
    auth_class.has_token?(cookies.fetch(:auth_token) { "" })
  end

  def self.authenticate(role, cookies, callbacks = {})
    current(role, cookies).authenticated? ||
      callbacks.fetch(:failure) { -> { } }.call
  end

  def self.current(profile, cookies)
    auth_class.find_profile_with_token(
      cookies.fetch(:auth_token) { "" }, profile
    )
  end

  private
  def self.auth_class
    Authentication
  end
end
