module FindAccount
  def self.call(token)
    auth_class.find_with_token(token)
  end

  def self.authenticate(profile, cookies, callbacks = {})
    current(profile, cookies).authenticated? ||
      callbacks.fetch(:failure) { -> { } }.call
  end

  def self.current(profile, cookies)
    auth_class.find_profile_with_token(
      cookies.fetch(:auth_token) { "" }, profile
    )
  end

  private
  def self.auth_class
    Account
  end
end
