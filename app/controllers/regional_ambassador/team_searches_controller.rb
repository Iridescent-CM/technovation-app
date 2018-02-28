module RegionalAmbassador
  class TeamSearchesController < RegionalAmbassadorController
    def show
      name_query = params.fetch(:name) { "" }

      scope = Team.current
        .joins(:submission)
        .where("name ILIKE ?", "#{name_query.split(" ")[0]}%")
        .where.not(id: params[:exclude_ids])

      results = scope.in_region(current_ambassador).limit(7)

      if results.count < 8
        results += scope.where.not(
          id: results.pluck(:id) + params[:exclude_ids].to_a
        )
        .limit(7 - results.count)
      end

      json = results.map do |team|
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
