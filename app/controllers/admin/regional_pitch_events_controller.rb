module Admin
  class RegionalPitchEventsController < AdminController
      include DatagridController

      use_datagrid with: EventsGrid

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

    def grid_params
      grid = (params[:events_grid] ||= {}).merge(
        admin: true,
        country: Array(params[:events_grid][:country]),
        state_province: Array(params[:events_grid][:state_province])
      )

      grid.merge(
        column_names: detect_extra_columns(grid),
      )
    end
  end
end
