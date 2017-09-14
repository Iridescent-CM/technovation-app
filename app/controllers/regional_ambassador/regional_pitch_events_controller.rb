module RegionalAmbassador
  class RegionalPitchEventsController < RegionalAmbassadorController
    def index
      @pitch_events = RegionalPitchEvent.in_region_of(current_ambassador)
    end

    def show
      @pitch_event = RegionalPitchEvent.in_region_of(current_ambassador)
        .includes(
          teams: [:division, { judge_assignments: :judge_profile }],
          judges: { judge_assignments: :team }
        ).find(params[:id])

      @senior_team_participants = Team.current
        .senior
        .for_ambassador(current_ambassador)
        .not_attending_live_event
        .distinct
        .sort { |t1, t2| t1.name.downcase <=> t2.name.downcase }

      @junior_team_participants = Team.current
        .junior
        .for_ambassador(current_ambassador)
        .not_attending_live_event
        .distinct
        .sort { |t1, t2| t1.name.downcase <=> t2.name.downcase }

      @judge_participants = JudgeProfile.current
        .includes(:judge_assignments)
        .onboarded
        .for_ambassador(current_ambassador)
        .not_attending_live_event
        .sort { |j1, j2| j1.first_name.downcase <=> j2.first_name.downcase }
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
