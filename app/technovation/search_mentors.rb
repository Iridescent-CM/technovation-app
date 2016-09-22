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

    mentors.searchable
  end
end
