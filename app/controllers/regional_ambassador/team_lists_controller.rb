module RegionalAmbassador
  class TeamListsController < RegionalAmbassadorController
    def show
      event = RegionalPitchEvent.find(params.fetch(:event_id))
      json = event.teams.map do |team|
        team.to_search_json.merge({
          view_url: regional_ambassador_team_path(
            team,
            allow_out_of_region: true,
          ),
        })
      end
      render json: json
    end
  end
end
