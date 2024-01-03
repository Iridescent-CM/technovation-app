module Admin
  class RegionalPitchEventsController < AdminController
    include DatagridController

    use_datagrid with: EventsGrid

    helper_method :back_from_event_path

    def show
      @event = RegionalPitchEvent.find(params[:id])
    end

    def edit
      @event = RegionalPitchEvent.find(params[:id])
    end

    def update
      @event = RegionalPitchEvent.find(params[:id])
      @event.update(regional_pitch_event_params)
      redirect_to admin_event_path(@event), success: "Changes were saved!"
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
        column_names: detect_extra_columns(grid)
      )
    end

    def back_from_event_path
      admin_events_path
    end
  end
end
