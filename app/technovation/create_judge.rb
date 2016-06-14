module CreateJudge
  def self.call(attrs)
    auth = CreateAuthentication.(attrs)
    role = UserRole.create(user: auth.user, role: Role.judge)
    role.expertise_ids = attrs.fetch(:expertise_ids) { [] }
    role.save
    auth.user
  end
end
