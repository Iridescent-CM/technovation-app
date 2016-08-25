module FindAccount
  def self.call(token)
    auth_class.find_with_token(token)
  end

  def self.authenticate(profile, cookies, callbacks = {})
    if current(profile, cookies).authenticated?
      true
    elsif account = call(cookies.fetch(:auth_token) { "" }).authenticated?
      callbacks.fetch(:unauthorized) { ->(*) { } }.call(account.type_name)
    else
      callbacks.fetch(:unauthenticated) { -> { } }.call
    end
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
