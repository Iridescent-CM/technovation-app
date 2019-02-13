module RegionalAmbassador
  class RegionalPitchEventsController < RegionalAmbassadorController
    helper_method :invitation_token

    def index
      respond_to do |f|
        f.html { }
        f.json {
          pitch_events = RegionalPitchEvent.current
            .in_region(current_ambassador)
            .order(:starts_at)
            .map do |e|
              e.to_list_json.merge({
                url: regional_ambassador_regional_pitch_event_path(
                  e,
                  format: :json
                ),
              })
            end

          render json: pitch_events
        }
      end
    end

    def show
      @pitch_event = RegionalPitchEvent.current
        .in_region(current_ambassador)
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
      @pitch_event = RegionalPitchEvent.current
        .in_region(current_ambassador)
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
            render json: @pitch_event.to_list_json.merge({
              url: regional_ambassador_regional_pitch_event_path(
                @pitch_event,
                format: :json
              ),
            })
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
        .in_region(current_ambassador)
        .find(params[:id])

      if @pitch_event.update_attributes(pitch_event_params)
        respond_to do |f|
          f.html {
            redirect_to [:regional_ambassador, @pitch_event],
              notice: 'Regional pitch event was successfully updated.'
          }

          f.json {
            render json: @pitch_event.to_list_json.merge({
              url: regional_ambassador_regional_pitch_event_path(
                @pitch_event,
                format: :json,
              ),
            })
          }
        end
      else
        respond_to do |f|
          f.html { render :edit }

          f.json {
            render json: { errors: @pitch_event.errors }, status: 400
          }
        end
      end
    end

    def destroy
      RegionalPitchEvent.current.in_region(current_ambassador)
        .find(params[:id]).destroy

      redirect_to regional_ambassador_regional_pitch_events_url,
        notice: 'Regional pitch event was successfully deleted.'
    end

    private
    def pitch_event_params
      params.require(:regional_pitch_event).permit(
        :name,
        :starts_at,
        :ends_at,
        :city,
        :venue_address,
        :event_link,
        :capacity,
        division_ids: [],
      )
    end

    def invitation_token
      (GlobalInvitation.active.last || NullInvitation.new("")).token
    end

    class NullInvitation < Struct.new(:token)
      def present?
        false
      end
    end
  end
end
