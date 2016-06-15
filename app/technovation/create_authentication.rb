module CreateAuthentication
  def self.call(attrs)
    auth = Authentication.new(email: attrs.fetch(:email),
                              password: attrs.fetch(:password),
                              password_confirmation: attrs.fetch(:password_confirmation))
    GenerateToken.(auth, :auth_token)

    if auth.save
      auth.authentication_roles.create(role: attrs.fetch(:role) { Role.no_role })
    end

    auth
  end
end
