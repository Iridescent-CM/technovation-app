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

  def self.current(profile, cookies)
    Account.joins("#{profile}_profile")
      .where("accounts.auth_token = ?", cookies.fetch(:auth_token) { "" })
      .first or Account::NoAuthFound.new
  end
end
