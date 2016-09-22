require 'will_paginate/array'

module SearchTeams
  def self.call(filter)
    teams = Team.current

    if filter.nearby.present?
      miles = filter.nearby == "anywhere" ? 40_000 : 50
      nearby = filter.nearby == "anywhere" ? filter.user.address_details : filter.nearby

      team_members = Account.joins(:seasons)
                            .references(:seasons)
                            .where("seasons.year = ?", Season.current.year)
                            .where("type = ? OR type = ?", "MentorAccount", "StudentAccount")
                            .near(nearby, miles)
                            .order('distance')

      ids = team_members.collect(&:id)

      teams = teams.joins(:memberships)
                   .references(:memberships)
                   .where("memberships.member_id IN (?)", ids)
    end

    teams = case filter.spot_available
            when true
              teams.select { |t| t.spot_available? }
            else
              teams
            end

    teams = case filter.has_mentor
            when true
              teams.select { |t| t.mentors.any? }
            when false
              teams.select { |t| t.mentors.empty? }
            else
              teams
            end

    teams.paginate(page: filter.page)
  end
end
