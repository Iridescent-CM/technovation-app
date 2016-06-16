module FindAuthenticationRole
  CALLBACKS = { failure: -> { } }

  def self.authenticated?(cookies)
    auth_class.has_token?(cookies.fetch(:auth_token) { "" })
  end

  def self.authenticate(role, cookies, callbacks = {})
    current(role, cookies).authenticated? ||
      CALLBACKS.merge(callbacks).fetch(:failure).call
  end

  def self.current(role, cookies)
    auth_class.find_role_with_token(
      cookies.fetch(:auth_token) { "" }, [role, :admin].uniq
    )
  end

  private
  def self.auth_class
    Authentication
  end
end
