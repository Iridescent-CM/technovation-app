module FindAccount
  def self.call(token)
    Account.find_with_token(token)
  end

  def self.authenticate(profile, cookies, callbacks = {})
    if current(profile, cookies).authenticated?
      true
    else
      account = call(cookies.fetch(:auth_token) { "" })

      if account.authenticated?
        callbacks.fetch(:unauthorized) { ->(*) { } }.call(account.type_name)
      else
        callbacks.fetch(:unauthenticated) { -> { } }.call
      end
    end
  end

  def self.current(type, cookies)
    a = Account.joins("#{type}_profile".to_sym)
      .where(auth_token: cookies.fetch(:auth_token) { "" })
      .first

    a && a.send("#{type}_profile") || Account::NoAuthFound.new
  end
end
