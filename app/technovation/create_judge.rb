module CreateJudge
  def self.call(attrs)
    auth = CreateAuthentication.(attrs)
    role = UserRole.create(user: auth.user, role: Role.judge)

    attrs.fetch(:expertises, []).each do |expertise|
      role.expertises << expertise
    end

    role.save

    auth.user
  end
end
