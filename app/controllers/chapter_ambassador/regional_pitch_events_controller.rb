module ChapterAmbassador
  class RegionalPitchEventsController < ChapterAmbassadorController
    include BulkAddJudgesToRegionalPitchEvent
    include BulkAddTeamsToRegionalPitchEvent
    include BulkDownloadSubmissionPitchPresentations
    include RegionalPitchEvents::AvailableJudges
    include RegionalPitchEvents::AvailableTeams

    def index
      respond_to do |f|
        f.html {}
        f.json {
          pitch_events = RegionalPitchEvent.current
            .in_region(current_ambassador)
            .order(:starts_at)
            .map do |e|
              e.to_list_json.merge({
                url: chapter_ambassador_regional_pitch_event_path(
                  e,
                  format: :json
                )
              })
            end

          render json: pitch_events
        }
      end
    end

    def show
      @event = RegionalPitchEvent
        .current
        .in_region(current_ambassador)
        .includes(teams: [:division])
        .includes(:team_submissions)
        .find(params[:id])

      render "admin/regional_pitch_events/show"
    end

    def edit
      @pitch_event = RegionalPitchEvent.current
        .in_region(current_ambassador)
        .find(params[:id])
    end

    def new
      @pitch_event = RegionalPitchEvent.new
    end

    def create
      @pitch_event = current_ambassador
        .regional_pitch_events
        .new(pitch_event_params)

      if @pitch_event.save
        redirect_to chapter_ambassador_event_path(@pitch_event),
          success: "Regional pitch event was successfully created."
      else
        render :new
      end
    end

    def update
      @pitch_event = RegionalPitchEvent.current
        .in_region(current_ambassador)
        .find(params[:id])

      if @pitch_event.update(pitch_event_params)
        redirect_to chapter_ambassador_event_path(@pitch_event),
          success: "Regional pitch event was successfully updated."
      else
        render :edit
      end
    end

    def destroy
      RegionalPitchEvent.current.in_region(current_ambassador)
        .find(params[:id]).destroy

      redirect_to chapter_ambassador_events_list_path,
        success: "Regional pitch event was successfully deleted."
    end

    def available_teams
      @event = RegionalPitchEvent.in_region(current_ambassador)
        .find(params[:id])
      @available_teams = load_available_teams_for_event(@event)

      if turbo_frame_request_id == "available-teams-frame"
        render partial: "admin/regional_pitch_events/available_teams",
          locals: {event: @event, teams: @available_teams}
      elsif turbo_frame_request_id == "available-teams-list"
        render partial: "admin/regional_pitch_events/available_teams_list",
          locals: {event: @event, teams: @available_teams}
      else
        redirect_to chapter_ambassador_event_path(@event)
      end
    end

    def available_judges
      @event = RegionalPitchEvent.in_region(current_ambassador)
        .find(params[:id])
      @available_judges = load_available_judges_for_event(@event)

      if turbo_frame_request_id == "available-judges-frame"
        render partial: "admin/regional_pitch_events/available_judges",
          locals: {event: @event, judges: @available_judges}
      elsif turbo_frame_request_id == "available-judges-list"
        render partial: "admin/regional_pitch_events/available_judges_list",
          locals: {event: @event, judges: @available_judges}
      else
        redirect_to chapter_ambassador_event_path(@event)
      end
    end

    private

    def pitch_event_params
      params.require(:regional_pitch_event).permit(
        :name,
        :event_date,
        :start_time,
        :end_time,
        :starts_at,
        :ends_at,
        :city,
        :venue_address,
        :event_link,
        :capacity_enabled,
        :capacity,
        :division_id,
        division_ids: []
      )
    end

    class NullInvitation < Struct.new(:token)
      def present?
        false
      end
    end
  end
end
