module SearchMentors
  def self.call(filter)
    mentors = if filter.expertise_ids.any?
      MentorAccount.by_expertise_ids(filter.expertise_ids)
    else
      MentorAccount
    end

    mentors = if filter.nearby.present?
      mentors.near(filter.nearby, 50)
    else
      mentors
    end

    mentors.searchable
  end
end
