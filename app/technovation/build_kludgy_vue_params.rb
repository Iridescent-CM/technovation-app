module BuildKludgyVueParams
  def self.call(teams, judges)
    teams = Array(teams)
    judges = Array(judges)

    self.kludgy_invite_params(
      *(teams.map { |team| self.email_invite_team(team) }),
      *(judges.map { |judge| self.email_invite_judge(judge) }),
    )
  end

  private
  # FIXME: These invites params are how the Vue app sends it
  # Probably can be cleaner - see controller for kludgy workaround
  def self.email_invite_judge(judge)
    self.invite_attendee(id: judge.id, scope: "JudgeProfile", send_email: true)
  end

  def self.email_invite_team(team)
    self.invite_attendee(id: team.id, scope: "Team", send_email: true)
  end

  def self.invite_attendee(id:, scope:, send_email:)
    { id: id,
      scope: scope,
      send_email: send_email }
  end

  def self.kludgy_invite_params(*attrs_groups)
    pars = {}

    attrs_groups.map.with_index do |attrs, i|
      pars[i] = [kludgy_invite_attrs(attrs)]
    end

    pars
  end

  def self.kludgy_invite_attrs(attrs)
    { "id" => attrs[:id],
      "scope" => attrs[:scope],
      "send_email" => attrs[:send_email] }
  end
end