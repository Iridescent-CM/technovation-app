module CreateAuthentication
  def self.call(attrs)
    auth = Authentication.new(attrs)
    GenerateToken.(auth, :auth_token)
    auth.save
    auth
  end
end
