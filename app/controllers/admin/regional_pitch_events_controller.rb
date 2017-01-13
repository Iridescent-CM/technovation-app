module Admin
  class RegionalPitchEventsController < AdminController
    def index
      @events = RegionalPitchEvent.all.paginate(
        per_page: params[:per_page], page: params[:page]
      )
    end

    def show
      @event = RegionalPitchEvent.find(params[:id])
    end
  end
end
