module RegionalAmbassador
  class JudgeListsController < RegionalAmbassadorController
    def show
      event = current_ambassador.regional_pitch_events
        .find(params.fetch(:event_id))

      render json: event.judge_list.map(&:to_search_json)
    end
  end
end
