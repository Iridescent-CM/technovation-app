class TeamCreating
  def self.execute(team, profile, context)
    if team.seasons.empty?
      RegisterToCurrentSeasonJob.perform_now(team)
    end

    team.create_activity(
      key: "team.create"
    )

    TeamRosterManaging.add(team, profile)

    if !!profile && profile.valid_coordinates?
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
