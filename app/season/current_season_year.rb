module CurrentSeasonYear
  def self.call
    if Date.current < season_switch_date
      Time.current.year
    else
      Time.current.year + 1
    end
  end

  private
  def self.season_switch_date
    Date.new(Time.current.year, 8, 1)
  end
end
