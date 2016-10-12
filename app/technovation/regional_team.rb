module RegionalTeam
  def self.call(ambassador)
    teams = Team.includes(:seasons)
                .references(:seasons)
                .where("seasons.year = ?", Season.current.year)

    if ambassador.country == "US"
      teams.select { |t| t.state_province == ambassador.state_province }
    else
      teams.select { |t| t.country == ambassador.country }
    end
  end
end
