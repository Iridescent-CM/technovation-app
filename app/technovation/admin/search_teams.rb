module Admin
  class SearchTeams
    def self.call(params)
      params[:per_page] = 25 if params[:per_page].blank?
      params[:division] = "All" if params[:division].blank?
      params[:mentor_status] = "All" if params[:mentor_status].blank?
      params[:season] = Season.current.year if params[:season].blank?

      teams = Team.joins(season_registrations: :season)
                  .where("season_registrations.season_id = ?",
                         Season.find_by(year: params[:season]))

      unless params[:text].blank?
        results = teams.search({
          query: {
            query_string: {
              query: params[:text]
            },
          },
          from: 0,
          size: 10_000
        }).results

        teams = teams.where(id: results.flat_map { |r| r._source.id })
      end

      case params[:division]
      when "All"
      else
        teams = teams.joins(:division)
          .where("divisions.name = ?", Division.names[params[:division].downcase])
      end

      case params[:mentor_status]
      when "All"
        teams
      when "Has mentor(s)"
        teams.joins(:mentors)
      when "Has no mentor"
        teams.eager_load(:memberships)
          .where("teams.id NOT IN
            (SELECT DISTINCT(team_id)
                    FROM memberships
                    WHERE memberships.member_type = 'MentorProfile')")
      end
    end
  end
end
