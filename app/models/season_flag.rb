class SeasonFlag
  attr_reader :account

  def initialize(account)
    @account = account
  end

  def text
    "#{type.titleize} #{account.scope_name.humanize.downcase}"
  end

  def type
    if !account.seasons.include?(Season.current.year)
      "past"
    elsif account.seasons.many?
      "returning"
    else
      "new"
    end
  end
end
