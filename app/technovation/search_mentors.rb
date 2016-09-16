module SearchMentors
  def self.call(filter)
    mentors = if filter.expertise_ids.any?
      MentorAccount.by_expertise_ids(filter.expertise_ids)
    else
      MentorAccount
    end

    if filter.nearby.present?
      mentors = mentors.near(filter.nearby, 50)
    end

    mentors.searchable
  end
end
