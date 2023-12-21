module ChapterAmbassador
  class JudgeListsController < ChapterAmbassadorController
    def show
      event = RegionalPitchEvent.find(params.fetch(:event_id))

      attendees = Attendees.for(
        event: event,
        type: :account,
        context: self
      )

      render json: AttendeesSerializer.new(attendees, is_collection: true).serialized_json
    end
  end
end
