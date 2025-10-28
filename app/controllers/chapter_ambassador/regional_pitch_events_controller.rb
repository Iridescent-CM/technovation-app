module ChapterAmbassador
  class RegionalPitchEventsController < ChapterAmbassadorController
    include BulkDownloadSubmissionPitchPresentations

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
        .includes(
          judges: :current_account,
          teams: [
            :division,
            submission: [:team, :screenshots]
          ]
        )
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
