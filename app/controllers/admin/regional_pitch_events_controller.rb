module Admin
  class RegionalPitchEventsController < AdminController
    def index
      params[:page] = 1 if params[:page].blank?
      params[:per_page] = 15 if params[:per_page].blank?
      params[:status] = "all" if params[:status].blank?

      @events = RegionalPitchEvent.public_send(params[:status])
        .page(params[:page].to_i)
        .per_page(params[:per_page].to_i)

      if @events.empty?
        @events = @events.page(1)
      end
    end

    def show
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
