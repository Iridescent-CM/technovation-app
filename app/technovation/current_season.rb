module CurrentSeason
  def self.year
    Season.current.year
  end

  def self.previous_year
    Season.current.year - 1
  end
end
