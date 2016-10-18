require 'will_paginate/array'

module SearchTeams
  def self.call(filter)
    teams = Team.current

    if filter.nearby.present?
      miles = filter.nearby == "anywhere" ? 40_000 : 50
      nearby = filter.nearby == "anywhere" ? filter.user.address_details : filter.nearby

      account_ids = Account.where(type: %w{MentorAccount StudentAccount})
                           .near(nearby, miles)
                           .collect(&:id)

      teams = teams.joins(:memberships)
                   .references(:memberships)
                   .where("memberships.member_id IN (?)", account_ids)
    end

    unless filter.text.blank?
      results = teams.search({
        query: {
          query_string: {
            query: "*#{filter.text}*"
          },
        },
        from: 0,
        size: 10_000
      }).results
      teams = teams.where(id: results.flat_map { |r| r._source.id })
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

    teams = case filter.user.type
            when "StudentAccount"
              teams.select(&:accepting_student_requests?)
            when "MentorAccount"
              teams.select(&:accepting_mentor_requests?)
            else
              teams
            end

    teams
  end
end
