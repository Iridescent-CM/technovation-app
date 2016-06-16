module CreateStudent
  def self.call(attrs)
    CreateAuthentication.(attrs.merge(role: Role.student))
  end
end

