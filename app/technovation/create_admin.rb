module CreateAdmin
  def self.call(attrs)
    auth = CreateAuthentication.(attrs)
    auth.build_admin_profile
    auth.save
    auth
  end
end
