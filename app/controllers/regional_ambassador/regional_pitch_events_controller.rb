module RegionalAmbassador
  class RegionalPitchEventsController < RegionalAmbassadorController
    def index
      pitch_events = RegionalPitchEvent.current
        .in_region_of(current_ambassador)
        .order(:starts_at)
        .map do |event|
          {
            id: event.id,
            name: event.name,
            city: event.city,
            venue_address: event.venue_address,
            division_names: event.division_names,
            division_ids: event.division_ids,
            day: event.day,
            date: event.date,
            time: event.time,
            tz: event.timezone,
            starts_at: event.starts_at,
            ends_at: event.ends_at,
            eventbrite_link: event.eventbrite_link,
            url: regional_ambassador_regional_pitch_event_path(
              event,
              format: :json
            ),
            errors: {},
          }
        end

      respond_to do |f|
        f.html { }
        f.json { render json: pitch_events }
      end
    end

    def show
      @pitch_event = RegionalPitchEvent.current.in_region_of(current_ambassador)
        .includes(
          teams: [:division, { judge_assignments: :judge_profile }],
          judges: { judge_assignments: :team }
        ).find(params[:id])

      @senior_team_participants = Team.current
        .senior
        .in_region(current_ambassador)
        .not_attending_live_event
        .distinct
        .sort { |t1, t2| t1.name.downcase <=> t2.name.downcase }

      @junior_team_participants = Team.current
        .junior
        .in_region(current_ambassador)
        .not_attending_live_event
        .distinct
        .sort { |t1, t2| t1.name.downcase <=> t2.name.downcase }

      @judge_participants = JudgeProfile.current
        .includes(:judge_assignments)
        .onboarded
        .in_region(current_ambassador)
        .not_attending_live_event
        .sort { |j1, j2|
          j1.first_name.downcase <=> j2.first_name.downcase
        }
    end

    def edit
      @pitch_event = RegionalPitchEvent.current.in_region_of(current_ambassador)
        .find(params[:id])
    end

    def create
      @pitch_event = current_ambassador
        .regional_pitch_events
        .new(pitch_event_params)

      if @pitch_event.save
        respond_to do |format|
          format.html {
            redirect_to [:regional_ambassador, @pitch_event],
              notice: 'Regional pitch event was successfully created.'
          }

          format.json {
            event = @pitch_event

            render json: {
              id: event.id,
              day: event.day,
              date: event.date,
              time: event.time,
              tz: event.timezone,
              url: regional_ambassador_regional_pitch_event_path(
                event,
                format: :json
              ),
            }
          }
        end
      else
        respond_to do |format|
          format.html { render :new }

          format.json {
            render json: {
              errors: @pitch_event.errors.messages,
            }, status: 400
          }
        end
      end
    end

    def update
      @pitch_event = RegionalPitchEvent.current
        .in_region_of(current_ambassador)
        .find(params[:id])

      if @pitch_event.update_attributes(pitch_event_params)
        respond_to do |f|
          f.html {
            redirect_to [:regional_ambassador, @pitch_event],
              notice: 'Regional pitch event was successfully updated.'
          }

          f.json {
            render json: {
              id: @pitch_event.id,
              url: regional_ambassador_regional_pitch_event_path(
                @pitch_event,
                format: :json,
              ),
              day: @pitch_event.day,
              date: @pitch_event.date,
              time: @pitch_event.time,
              tz: @pitch_event.timezone,
            }
          }
        end
      else
        respond_to do |f|
          f.html { render :edit }

          format.json {
            render json: { errors: @pitch_event.errors }, status: 400
          }
        end
      end
    end

    def destroy
      RegionalPitchEvent.current.in_region_of(current_ambassador)
        .find(params[:id]).destroy

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
