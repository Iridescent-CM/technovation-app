module CreateJudge
  def self.call(attrs)
    auth = CreateAuthentication.(attrs.merge(roles: [Role.judge]))

    attrs.fetch(:expertises, {}).each do |expertise|
      auth.user.add_expertise(expertise)
    end

    auth.user.save

    auth.user
  end
end
