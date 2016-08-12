module SeasonYear
  def self.call(date)
    date < season_switch_date ? date.year : date.year + 1
  end

  private
  def self.season_switch_date
    Date.new(Time.current.year, 8, 1)
  end
end
