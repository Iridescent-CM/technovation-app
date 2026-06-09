module RegionalPitchEvents::AdminAvailableTeams
  private

  def load_available_teams_for_event(event)
    teams = Team.live_event_eligible(event)
      .includes(:division, submission: :team)
      .order("teams.name")

    teams = teams.by_query(params[:query]) if params[:query].present?

    teams.paginate(page: params[:page], per_page: 20)
  end
end
