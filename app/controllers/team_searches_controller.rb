class TeamSearchesController < ActionController::API
  def show
    searching = TeamSearching.new(params[:q])
    results = searching.get_team_matches
    render json: {
      q: params[:q],
      results: results.as_json(
        only: %i{id name},
        methods: :link_to_path
      ),
    }
  end

  class TeamSearching
    def initialize(query, teams = Team)
      @query = query
      @teams = teams
    end

    def get_team_matches
      sleep 2
      if @query.blank?
        @teams.none
      else
        @teams.select(:id, :name).order(:name).where("name ILIKE ?", "#{@query}%")
      end
    end
  end
end
