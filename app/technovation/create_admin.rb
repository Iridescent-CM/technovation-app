module CreateAdmin
  def self.call(attrs)
    account = CreateAccount.(attrs)
    account.build_admin_profile
    account.save
    account
  end
end
