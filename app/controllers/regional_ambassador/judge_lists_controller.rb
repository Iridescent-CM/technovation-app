module RegionalAmbassador
  class JudgeListsController < RegionalAmbassadorController
    def show
      event = RegionalPitchEvent.find(params.fetch(:event_id))

      render json: Attendees.for(
        event: event,
        type: :account,
        context: self,
      )
    end
  end
end
