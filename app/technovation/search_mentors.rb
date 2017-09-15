module SearchMentors
  EARTH_CIRCUMFERENCE = 24_901

  def self.call(filter)
    mentors = MentorProfile.searchable(filter.mentor_account_id)

    unless filter.text.blank?
      names = filter.text.split(' ')
      mentors = mentors.joins(:account).where(
        "accounts.first_name ilike '%#{names.first}%' OR
        accounts.last_name ilike '%#{names.last}%'"
      )
    end

    if filter.expertise_ids.any?
      mentors = mentors.by_expertise_ids(filter.expertise_ids)
    end

    if filter.gender_identities.any?
      mentors = mentors.by_gender_identities(filter.gender_identities)
    end

    if filter.needs_team
      profile_ids = MentorProfile.where("mentor_profiles.id NOT IN
        (SELECT DISTINCT(member_id) FROM memberships
                                    WHERE memberships.member_type = 'MentorProfile'
                                    AND memberships.team_id IN

          (SELECT DISTINCT(id) FROM teams WHERE teams.id IN

            (SELECT DISTINCT(registerable_id) FROM season_registrations
                                              WHERE season_registrations.registerable_type = 'Team'
                                              AND season_registrations.season_id = ?)))", Season.current.id)
        .pluck(:id)

      mentors = mentors.where(id: profile_ids)
    end

    if filter.on_team
      profile_ids = MentorProfile.where("mentor_profiles.id IN
        (SELECT DISTINCT(member_id) FROM memberships
                                    WHERE memberships.member_type = 'MentorProfile'
                                    AND memberships.team_id IN

          (SELECT DISTINCT(id) FROM teams WHERE teams.id IN

            (SELECT DISTINCT(registerable_id) FROM season_registrations
                                              WHERE season_registrations.registerable_type = 'Team'
                                              AND season_registrations.season_id = ?)))", Season.current.id)
        .pluck(:id)

      mentors = mentors.where(id: profile_ids)
    end

    if filter.virtual_only
      mentors = mentors.virtual
    end

    miles = filter.nearby == "anywhere" ? EARTH_CIRCUMFERENCE : 100
    nearby = filter.nearby == "anywhere" ? filter.location : filter.nearby

    if filter.country == "PS"
      nearby = "Palestine"
    end

    mentors.joins(:account).near(nearby, miles)
  end
end
