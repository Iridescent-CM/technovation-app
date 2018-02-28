module RegionalAmbassador
  class JudgeListsController < RegionalAmbassadorController
    def show
      event = current_ambassador.regional_pitch_events
        .find(params.fetch(:event_id))

      json = event.judge_list.map do |judge|
        if judge.is_a?(JudgeProfile)
          judge.to_search_json.merge({
            view_url: regional_ambassador_participant_path(
              judge.account,
              allow_out_of_region: true,
            ),
          })
        else
          judge.to_search_json
        end
      end

      render json: json
    end
  end
end
