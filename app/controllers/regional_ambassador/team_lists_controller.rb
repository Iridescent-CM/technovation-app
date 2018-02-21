module RegionalAmbassador
  class TeamListsController < RegionalAmbassadorController
    def show
      event = RegionalPitchEvent.find(params.fetch(:event_id))
      render json: event.teams.map(&:to_search_json)
    end
  end
end
