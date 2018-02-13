module RegionalAmbassador
  class JudgeListsController < RegionalAmbassadorController
    def show
      event = current_ambassador.regional_pitch_events
        .find(params.fetch(:event_id))

      judges = event.judges.map do |judge|
        {
          id: judge.id,
          name: judge.full_name,
          email: judge.email,
        }
      end

      render json: judges
    end
  end
end
