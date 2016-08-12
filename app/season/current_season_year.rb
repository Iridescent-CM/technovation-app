module CurrentSeasonYear
  def self.call
    SeasonYear.(Date.current)
  end
end
