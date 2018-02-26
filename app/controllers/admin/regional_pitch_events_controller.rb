module Admin
  class RegionalPitchEventsController < AdminController
    def index
      @events = RegionalPitchEvent.where(
        "starts_at > ?", Date.new(Season.current.year, 1, 1)
      )
    end

    def show
      @event = RegionalPitchEvent.find(params[:id])
    end

    def edit
      @event = RegionalPitchEvent.find(params[:id])
    end

    def update
      @event = RegionalPitchEvent.find(params[:id])
      @event.update_attributes(regional_pitch_event_params)
      redirect_to [:admin, @event], success: "Changes were saved!"
    end

    private
    def regional_pitch_event_params
      params.require(:regional_pitch_event).permit(:unofficial)
    end
  end
end
