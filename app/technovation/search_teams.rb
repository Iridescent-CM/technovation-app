module SearchTeams
  def self.call(filter)
    teams = if filter.nearby.present?
              StudentAccount.near(filter.nearby, 50).collect(&:team).compact.uniq
            else
              Team.all
            end

    if filter.has_mentor
      teams.select { |t| t.mentors.any? }
    else
      teams.select { |t| t.mentors.empty? }
    end
  end
end
