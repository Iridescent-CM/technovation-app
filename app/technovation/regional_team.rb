module RegionalTeam
  def self.call(ambassador, params = {})
    teams = Team.includes(:seasons, :memberships)
                .references(:seasons)
                .where("seasons.year = ?", Season.current.year)

    if ambassador.country == "US"
      teams = teams.where("teams.id IN (
        SELECT memberships.joinable_id FROM memberships WHERE memberships.member_id IN (
          SELECT accounts.id FROM accounts WHERE accounts.state_province = ?
        )
      )", ambassador.state_province).uniq
    else
      teams = teams.where("teams.id IN (
        SELECT memberships.joinable_id FROM memberships WHERE memberships.member_id IN (
          SELECT accounts.id FROM accounts WHERE accounts.country = ?
        )
      )", ambassador.country).uniq
    end

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

    if !!params[:division] and params[:division] != "All"
      division = Division.names[params[:division].downcase]

      teams = teams.includes(:division)
                   .references(:divisions)
                   .where("divisions.name = ?", division)
    end

    case params[:mentor_status]
    when "With Mentor(s)"
      teams.where("teams.id IN (
        SELECT memberships.joinable_id FROM memberships WHERE memberships.member_type = ?
      )", "MentorAccount").uniq
    when "Without Mentor"
      teams.where("teams.id NOT IN (
        SELECT memberships.joinable_id FROM memberships WHERE memberships.member_type = ?
      )", "MentorAccount").uniq
    else
      teams
    end
  end
end
