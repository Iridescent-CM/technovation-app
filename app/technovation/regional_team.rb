module RegionalTeam
  def self.call(ambassador, params = {})
    teams = Team.current
                .in_region(ambassador)
                .order('teams.created_at DESC')

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

    if !!params[:division] and params[:division] != "All"
      division = Division.names[params[:division].downcase]

      teams = teams.includes(:division)
                   .references(:divisions)
                   .where("divisions.name = ?", division)
    end

    case params[:mentor_status]
    when "With Mentor(s)"
      teams.where("teams.id IN (
        SELECT memberships.team_id FROM memberships WHERE memberships.member_type = ?
      )", "MentorProfile").distinct
    when "Without Mentor"
      teams.where("teams.id NOT IN (
        SELECT memberships.team_id FROM memberships WHERE memberships.member_type = ?
      )", "MentorProfile").distinct
    else
      teams
    end
  end
end
