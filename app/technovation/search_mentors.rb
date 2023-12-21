module SearchMentors
  EARTH_CIRCUMFERENCE = 24_901

  def self.call(filter)
    mentors = MentorProfile.searchable(filter.mentor_account_id)

    unless filter.text.blank?
      names = filter.text.split(" ")
      mentors = mentors.joins(:account).where(
        "accounts.first_name ilike '%#{names.first}%' OR
        accounts.last_name ilike '%#{names.last}%'"
      )
    end

    if filter.expertise_ids.any?
      mentors = mentors.by_expertise_ids(filter.expertise_ids)
    end

    if filter.female_only
      mentors = mentors.by_gender_identities([Account.genders["Female"]])
    end

    if filter.needs_team
      profile_ids = MentorProfile.eager_load(:current_teams)
        .references(:teams)
        .where("teams.id IS NULL")
        .pluck(:id)

      mentors = mentors.where(id: profile_ids)
    end

    if filter.on_team
      mentors = mentors.where(id: MentorProfile.joins(:current_teams).pluck(:id))
    end

    if filter.virtual_only
      mentors = mentors.virtual
    end

    miles = (filter.nearby == "anywhere") ? EARTH_CIRCUMFERENCE : 100
    nearby = (filter.nearby == "anywhere") ? filter.coordinates : filter.nearby

    if filter.country == "PS"
      nearby = "Palestine"
    end

    mentors.joins(:account).near(nearby, miles)
  end
end
