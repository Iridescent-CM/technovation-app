module RegionalAmbassador
  class PossibleEventAttendeesController < RegionalAmbassadorController
    def index
      possible_attendees = Attendees.for(
        ambassador: current_ambassador,
        type: params.fetch(:type),
        context: self,
      )

      render json: possible_attendees
    end
  end
end
