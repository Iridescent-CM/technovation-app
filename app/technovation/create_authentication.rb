module CreateAuthentication
  def self.call(attrs)
    auth = Authentication.new(email: attrs.fetch(:email),
                              password: attrs.fetch(:password),
                              password_confirmation: attrs.fetch(:password_confirmation))
    GenerateToken.(auth, :auth_token)
    auth.build_user(roles: attrs.fetch(:roles, []))
    auth.save
    auth
  end
end
