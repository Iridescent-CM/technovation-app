class TeamCreating
  def self.execute(team, profile)
    if team.season_ids.empty?
      RegisterToSeasonJob.perform_later(team)
    end

    TeamRosterManaging.add(team, profile)

    team.latitude = profile.latitude
    team.longitude = profile.longitude
    Geocoding.perform(team).with_save
  end
end
