module RegionalAmbassador
  class TeamSearchesController < RegionalAmbassadorController
    def show
      name_query = params.fetch(:name) { "" }

      scope = Team.current
        .where("name ILIKE ?", "#{name_query.split(" ")[0]}%")
        .where.not(id: params[:exclude_ids])

      results = scope.in_region(current_ambassador).limit(7)

      if results.count < 8
        results += scope.where.not(
          id: results.pluck(:id) + params[:exclude_ids].to_a
        )
        .limit(7 - results.count)
      end

      render json: results.map(&:to_search_json)
    end
  end
end
