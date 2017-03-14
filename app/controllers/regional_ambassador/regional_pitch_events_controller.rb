module RegionalAmbassador
  class RegionalPitchEventsController < RegionalAmbassadorController
    def index
      @pitch_events = current_ambassador.regional_pitch_events
    end

    def show
      @pitch_event = current_ambassador.regional_pitch_events.find(params[:id])
    end

    def new
      @pitch_event = current_ambassador.regional_pitch_events.build
      @pitch_event.starts_at = Date.new(Season.current.year, 5, 1)
      @pitch_event.ends_at = @pitch_event.starts_at + 1.hour
    end

    def edit
      @pitch_event = current_ambassador.regional_pitch_events.find(params[:id])
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
      @pitch_event = current_ambassador.regional_pitch_events.find(params[:id])

      if @pitch_event.update_attributes(pitch_event_params)
        redirect_to [:regional_ambassador, @pitch_event], notice: 'Regional pitch event was successfully updated.'
      else
        render :edit
      end
    end

    def destroy
      current_ambassador.regional_pitch_events.find(params[:id]).destroy
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
