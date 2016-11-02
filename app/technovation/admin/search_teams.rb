module Admin
  class SearchTeams
    def self.call(params)
      params[:per_page] = 25 if params[:per_page].blank?
      params[:division] = "All" if params[:division].blank?
      params[:season] = Season.current.year if params[:season].blank?

      teams = Team.joins(season_registrations: :season)
                  .where("season_registrations.season_id = ?",
                         Season.find_by(year: params[:season]))

      unless params[:text].blank?
        results = teams.search({
          query: {
            query_string: {
              query: "*#{params[:text]}*"
            },
          },
          from: 0,
          size: 10_000
        }).results

        teams = teams.where(id: results.flat_map { |r| r._source.id })
      end

      case params[:division]
      when "All"
        teams
      else
        teams.joins(:division).where("divisions.name = ?",
                                     Division.names[params[:division].downcase])
      end
    end
  end
end
