module RegionalAmbassador
  class PossibleEventAttendeesController < RegionalAmbassadorController
    def index
      possible_attendees = Attendees.for(
        ambassador: current_ambassador,
        type: params.fetch(:type),
        query: params.fetch(:query),
        expand_search: expand_search?,
        context: self,
      )

      render json: possible_attendees
    end

    private
    def expand_search?
      %w(true 1 yes).include?(params.fetch(:expand_search))
    end
  end
end
