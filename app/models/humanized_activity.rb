module HumanizedActivity
  def self.call(key, params = {})
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
      "started their submission"
    when "submission.update"
      "updated their #{params[:piece].humanize}"
    else
      key
    end
  end
end
