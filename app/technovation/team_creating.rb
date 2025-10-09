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
      team.reverse_geocode
      team.save

      sucess_message = if context.class.to_s.include?("Ambassador") ||
          context.class.to_s.include?("Admin")
        I18n.t("controllers.teams.create.admin.success", full_name: profile.full_name)
      else
        I18n.t("controllers.teams.create.success")
      end

      context.redirect_to context.send(:"#{context.current_scope}_team_path", team),
        success: sucess_message
    else
      context.redirect_to(
        context.send(:"edit_#{context.current_scope}_team_location_path", team),
        success: "Welcome to Technovation, #{team.name}! Please set the team's location"
      )
    end
  end
end
