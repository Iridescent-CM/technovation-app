module Admin
  class RegionalPitchEventsController < AdminController
    include DatagridController
    include BulkDownloadSubmissionPitchPresentations
    include RegionalPitchEvents::AdminAvailableTeams
    include RegionalPitchEvents::BulkAddJudgesToRegionalPitchEvent
    include RegionalPitchEvents::BulkAddTeamsToRegionalPitchEvent

    use_datagrid with: EventsGrid

    helper_method :back_from_event_path

    def show
      @event = RegionalPitchEvent
        .includes(
          judges: :current_account,
          teams: [
            :division,
            submission: [:team, :screenshots]
          ]
        )
        .find(params[:id])
    end

    def edit
      @event = RegionalPitchEvent.find(params[:id])
    end

    def update
      @event = RegionalPitchEvent.find(params[:id])
      @event.update(regional_pitch_event_params)
      redirect_to admin_event_path(@event), success: "Changes were saved!"
    end

    def available_teams
      @event = RegionalPitchEvent.find(params[:id])
      @available_teams = load_available_teams_for_event(@event)

      if turbo_frame_request_id == "available-teams-frame"
        render partial: "admin/regional_pitch_events/available_teams",
          locals: {event: @event, teams: @available_teams}
      elsif turbo_frame_request_id == "available-teams-list"
        render partial: "admin/regional_pitch_events/available_teams_list",
          locals: {event: @event, teams: @available_teams}
      else
        redirect_to admin_event_path(@event)
      end
    end

    private

    def regional_pitch_event_params
      params.require(:regional_pitch_event).permit(:unofficial)
    end

    def grid_params
      grid = (params[:events_grid] ||= {}).merge(
        admin: true,
        country: Array(params[:events_grid][:country]),
        state_province: Array(params[:events_grid][:state_province])
      )

      grid.merge(
        column_names: detect_extra_columns(grid)
      )
    end

    def back_from_event_path
      admin_events_path
    end
  end
end
