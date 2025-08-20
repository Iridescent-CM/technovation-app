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

    def create
      @pitch_event = current_ambassador
        .regional_pitch_events
        .new(pitch_event_params)

      if @pitch_event.save
        respond_to do |format|
          format.html {
            redirect_to chapter_ambassador_path(@pitch_event),
              notice: "Regional pitch event was successfully created."
          }

          format.json {
            render json: @pitch_event.to_list_json.merge({
              url: chapter_ambassador_regional_pitch_event_path(
                @pitch_event,
                format: :json
              )
            })
          }
        end
      else
        respond_to do |format|
          format.html { render :new }

          format.json {
            render json: {
              errors: @pitch_event.errors.messages
            }, status: 400
          }
        end
      end
    end

    def update
      @pitch_event = RegionalPitchEvent.current
        .in_region(current_ambassador)
        .find(params[:id])

      if @pitch_event.update(pitch_event_params)
        respond_to do |f|
          f.html {
            redirect_to chapter_ambassador_path(@pitch_event),
              notice: "Regional pitch event was successfully updated."
          }

          f.json {
            render json: @pitch_event.to_list_json.merge({
              url: chapter_ambassador_regional_pitch_event_path(
                @pitch_event,
                format: :json
              )
            })
          }
        end
      else
        respond_to do |f|
          f.html { render :edit }

          f.json {
            render json: {errors: @pitch_event.errors}, status: 400
          }
        end
      end
    end

    def destroy
      RegionalPitchEvent.current.in_region(current_ambassador)
        .find(params[:id]).destroy

      respond_to do |format|
        format.html {
          redirect_to chapter_ambassador_regional_pitch_events_url,
            notice: "Regional pitch event was successfully deleted."
        }

        format.json {
          render json: {notice: "Regional pitch event was successfully deleted."}
        }
      end
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
