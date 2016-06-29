module SearchMentors
  def self.call(filter)
    if filter.expertise_ids.any?
      Mentor.by_expertise_ids(filter.expertise_ids)
    else
      Mentor.all
    end
  end
end
