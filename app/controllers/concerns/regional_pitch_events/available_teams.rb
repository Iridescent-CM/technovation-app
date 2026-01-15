module RegionalPitchEvents::AvailableTeams
  private

  def load_available_teams_for_event(event)
    teams = if params[:query].present?
      Team
        .available_for_event(event, current_ambassador)
        .by_query(params[:query])
    else
      Team.available_for_event(event, current_ambassador)
    end

    teams.paginate(page: params[:page], per_page: 20)
  end
end
