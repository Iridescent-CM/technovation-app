module CreateAdmin
  def self.call(attrs)
    CreateAuthentication.(attrs.merge(role: Role.admin))
  end
end
