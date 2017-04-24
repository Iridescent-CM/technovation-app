module RegionalAmbassador
  class RegionalPitchEventsController < RegionalAmbassadorController
    def index
      @pitch_events = RegionalPitchEvent.in_region_of(current_ambassador)
    end

    def show
      @pitch_event = RegionalPitchEvent.in_region_of(current_ambassador)
        .includes(
          teams: [:division, :team_submissions, { judge_assignments: :judge_profile }],
          judges: { judge_assignments: :team }
        ).find(params[:id])

      @senior_team_participants = Team.current
        .order("teams.name")
        .senior
        .for_ambassador(current_ambassador)
        .not_attending_live_event
        .distinct

      @junior_team_participants = Team.current
        .order("teams.name")
        .junior
        .for_ambassador(current_ambassador)
        .not_attending_live_event
        .distinct

      @judge_participants = JudgeProfile.current
        .order("accounts.first_name")
        .full_access
        .for_ambassador(current_ambassador)
        .not_attending_live_event
    end

    def new
      @pitch_event = current_ambassador.regional_pitch_events.build
      @pitch_event.starts_at = Date.new(Season.current.year, 5, 1).in_time_zone(current_ambassador.timezone)
      @pitch_event.ends_at = (@pitch_event.starts_at + 1.hour).in_time_zone(current_ambassador.timezone)
    end

    def edit
      @pitch_event = RegionalPitchEvent.in_region_of(current_ambassador).find(params[:id])
    end

    def create
      @pitch_event = current_ambassador.regional_pitch_events.new(pitch_event_params)

      if @pitch_event.save
        redirect_to [:regional_ambassador, @pitch_event], notice: 'Regional pitch event was successfully created.'
      else
        render :new
      end
    end

    def update
      @pitch_event = RegionalPitchEvent.in_region_of(current_ambassador).find(params[:id])

      if @pitch_event.update_attributes(pitch_event_params)
        redirect_to [:regional_ambassador, @pitch_event], notice: 'Regional pitch event was successfully updated.'
      else
        render :edit
      end
    end

    def destroy
      RegionalPitchEvent.in_region_of(current_ambassador).find(params[:id]).destroy
      redirect_to regional_ambassador_regional_pitch_events_url,
        notice: 'Regional pitch event was successfully destroyed.'
    end

    private
    def pitch_event_params
      params.require(:regional_pitch_event).permit(
        :name,
        :starts_at,
        :ends_at,
        :city,
        :venue_address,
        :eventbrite_link,
        division_ids: [],
      )
    end
  end
end
