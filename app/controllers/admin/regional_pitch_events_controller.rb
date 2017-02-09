module Admin
  class RegionalPitchEventsController < AdminController
    def index
      params[:page] = 1 if params[:page].blank?
      params[:per_page] = 15 if params[:per_page].blank?

      @events = RegionalPitchEvent.all
        .page(params[:page].to_i)
        .per_page(params[:per_page].to_i)

      if @events.empty?
        @events = @events.page(1)
      end
    end

    def show
      @event = RegionalPitchEvent.find(params[:id])
    end
  end
end
