module CreateJudge
  def self.call(attrs)
    auth = CreateAuthentication.(attrs.merge(role: Role.judge))
    role = auth.judge_role

    role.expertise_ids = attrs.fetch(:expertise_ids) { [] }
    role.save

    auth
  end
end
