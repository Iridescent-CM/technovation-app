module RegionalTeam
  def self.call(ambassador, params = {})
    teams = Team.includes(:seasons, :memberships)
                .references(:seasons, :accounts)
                .where("seasons.year = ?", Season.current.year)
                .order('teams.created_at DESC')

    if ambassador.country == "US"
      students = StudentProfile.joins(:account)
        .where("accounts.state_province = ? AND accounts.country = ?", ambassador.state_province, "US")
      mentors = MentorProfile.joins(:account)
        .where("accounts.state_province = ? AND accounts.country = ?", ambassador.state_province, "US")

      teams = teams.where(id: (students + mentors).flat_map(&:teams).uniq.map(&:id))
    else
      students = StudentProfile.joins(:account)
        .where("accounts.country = ?", ambassador.country)
      mentors = MentorProfile.joins(:account)
        .where("accounts.country = ?", ambassador.country)

      teams = teams.where(id: (students + mentors).flat_map(&:teams).uniq.map(&:id))
    end

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
        SELECT memberships.joinable_id FROM memberships WHERE memberships.member_type = ?
      )", "MentorProfile").distinct
    when "Without Mentor"
      teams.where("teams.id NOT IN (
        SELECT memberships.joinable_id FROM memberships WHERE memberships.member_type = ?
      )", "MentorProfile").distinct
    else
      teams
    end
  end
end
