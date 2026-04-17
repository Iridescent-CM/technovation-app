module RegionalPitchEvents::AvailableTeams
  extend ActiveSupport::Concern

  def available_teams
    @event = if current_scope == "admin"
      RegionalPitchEvent.current.find(params[:id])
    else
      RegionalPitchEvent.current.in_region(current_ambassador).find(params[:id])
    end
    @available_teams = load_available_teams_for_event(@event)

    if turbo_frame_request_id == "available-teams-frame"
      render partial: "admin/regional_pitch_events/available_teams",
        locals: {event: @event, teams: @available_teams}
    elsif turbo_frame_request_id == "available-teams-list"
      render partial: "admin/regional_pitch_events/available_teams_list",
        locals: {event: @event, teams: @available_teams}
    else
      redirect_to send("#{current_scope}_event_path", @event)
    end
  end

  private

  def load_available_teams_for_event(event)
    ambassador = current_scope == "admin" ? event.ambassador : current_ambassador
    teams = if params[:query].present?
      Team
        .available_for_event(event, ambassador)
        .by_query(params[:query])
    else
      Team.available_for_event(event, ambassador)
    end

    teams.paginate(page: params[:page], per_page: 20)
  end
end
