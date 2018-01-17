module HumanizedActivity
  def self.call(key)
    case key
    when "account.create"
      "signed up"
    when "account.join_team"
      "joined a team"
    when "account.leave_team"
      "left a team"
    when "account.update"
      "updated their profile"
    when "team.create"
      "was created"
    when "team.update"
      "was updated"
    when /register_current_season/
      "registered for the #{Season.current.year} season"
    when "submission.create"
      "created a submission"
    when "submission.update"
      "updated their submission"
    else
      key
    end
  end
end
