module SearchMentors
  def self.call(filter)
    if filter.expertise_ids.any?
      MentorAccount.by_expertise_ids(filter.expertise_ids)
    else
      MentorAccount.all
    end
  end
end
