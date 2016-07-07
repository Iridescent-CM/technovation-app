module DefaultSeasonStartTime
  def self.call
    Time.new(CurrentSeasonYear.(), 1, 1, 9, 0, 0, "-08:00")
  end
end
