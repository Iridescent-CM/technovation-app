module SearchTeams
  def self.call(filter)
    teams = if filter.nearby.present?
              student_ids = StudentAccount.near(filter.nearby, 50).collect(&:id)

              Team.current
                  .joins(:memberships)
                  .where("memberships.member_id IN (?)", student_ids)
            else
              Team.current
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
