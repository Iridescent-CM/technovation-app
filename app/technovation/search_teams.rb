require 'will_paginate/array'

module SearchTeams
  EARTH_CIRCUMFERENCE = 24_901

  def self.call(filter)
    teams = Team.current

    unless filter.text.blank?
      teams = teams.where("name ilike '%#{filter.text}%'")
    end

    divisions = Division.where(name: filter.division_enums)
    teams = teams.where(division: divisions)

    teams = case filter.has_mentor
            when true
              teams.joins(:mentors)
            when false
              teams.joins(:mentors).where("memberships.member_id IS NULL")
            else
              teams
            end

    teams = case filter.scope
            when "student"
              teams.accepting_student_requests
            when "mentor"
              teams.accepting_mentor_requests
            else
              teams
            end

    miles = filter.nearby == "anywhere" ? EARTH_CIRCUMFERENCE : 100
    nearby = filter.nearby == "anywhere" ? filter.location : filter.nearby

    if filter.country == "PS"
      nearby = "Palestine"
    end

    teams.near(nearby, miles)
  end

  def self.use_search_index(filter)
    not filter.text.blank? or filter.spot_available
  end
end
