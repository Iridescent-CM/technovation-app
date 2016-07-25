module SearchTeams
  def self.call(filter)
    teams = if filter.nearby.present?
              StudentAccount.near(filter.nearby, 50).collect(&:team).compact.uniq
            else
              Team.all
            end

    case filter.has_mentor
    when true
      teams.select { |t| t.mentors.any? }
    when false
      teams.select { |t| t.mentors.empty? }
    when :any
      teams
    else
      teams
    end
  end
end
