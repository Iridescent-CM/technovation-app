module DefaultSeasonStartTime
  def self.call(year = CurrentSeasonYear.())
    Time.new(year, 1, 1, 9, 0, 0, "-08:00")
  end
end
