class TeamCreating
  def self.execute(team, profile, context)
    if ENV.fetch("SEARCH_INDEX_TIMING") { "delayed" } == "realtime"
      IndexModelJob.perform_later("index", "Team", team.id)
    end

    if team.season_ids.empty?
      RegisterToSeasonJob.perform_later(team)
    end

    TeamRosterManaging.add(team, profile)

    if profile.longitude.present? and profile.latitude.present?
      team.latitude = profile.latitude
      team.longitude = profile.longitude
      Geocoding.perform(team).with_save

      context.redirect_to [context.current_scope, team],
        success: I18n.t("controllers.teams.create.success")
    else
      context.redirect_to(
        context.send("edit_#{context.current_scope}_team_location_path", team),
        success: "Welcome to Technovation, #{team.name}! Please set the team's location"
      )
    end
  end
end
