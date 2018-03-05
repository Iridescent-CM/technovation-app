module RegionalAmbassador
  class TeamListsController < RegionalAmbassadorController
    def show
      event = RegionalPitchEvent.find(params.fetch(:event_id))

      render json: Attendees.for(
        event: event,
        type: :team,
        context: self,
      )
    end
  end
end
