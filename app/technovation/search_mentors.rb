module SearchMentors
  def self.call(filter)
    mentors = if filter.expertise_ids.any?
      MentorAccount.by_expertise_ids(filter.expertise_ids)
    else
      MentorAccount
    end

    if filter.nearby.present?
      miles = filter.nearby == "anywhere" ? 40_000 : 50
      nearby = filter.nearby == "anywhere" ? filter.user.address_details : filter.nearby

      mentors = mentors.near(nearby, miles).order("distance")
    end

    if filter.needs_team
      mentors = mentors.where("accounts.id NOT IN
        (SELECT DISTINCT(member_id) FROM memberships
                                    WHERE memberships.member_type = 'MentorAccount'
                                    AND memberships.joinable_type = 'Team'
                                    AND memberships.joinable_id IN

          (SELECT DISTINCT(id) FROM teams WHERE teams.id IN

            (SELECT DISTINCT(registerable_id) FROM season_registrations
                                              WHERE season_registrations.registerable_type = 'Team'
                                              AND season_registrations.season_id = ?)))", Season.current.id)
    end

    mentors.searchable
  end
end
