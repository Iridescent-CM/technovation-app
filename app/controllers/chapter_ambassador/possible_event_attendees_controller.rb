module ChapterAmbassador
  class PossibleEventAttendeesController < ChapterAmbassadorController
    def index
      possible_attendees = Attendees.for(
        ambassador: current_ambassador,
        event: event,
        type: params.fetch(:type),
        query: params.fetch(:query),
        expand_search: expand_search?,
        context: self,
        exclude_event_attendees: true
      )

      render json: AttendeesSerializer.new(possible_attendees, is_collection: true).serialized_json
    end

    private

    def event
      @event ||= RegionalPitchEvent.find(params.fetch(:event_id))
    end

    def expand_search?
      %w[true 1 yes].include?(params.fetch(:expand_search))
    end
  end
end
