module RegionalAmbassador
  module SearchTeamSubmissions
    def self.call(params, ambassador)
      params[:division] = "all" if params[:division].blank?

      submissions = TeamSubmission.joins(team: [:division, :memberships])
        .where("teams.id IN (?)", Team.for_ambassador(ambassador).pluck(:id))
        .distinct

      case params[:division]
      when 'all'
      else
        submissions = submissions.where("divisions.name = ?",
                                        Division.names[params[:division]])
      end

      unless params[:team_name].blank?
        submissions = submissions.where("LOWER(teams.name) LIKE ?",
                                        "%#{params[:team_name].downcase}%")
      end

      case params[:status]
      when 'complete'
        submissions = submissions.select(&:complete?)
      when 'incomplete'
        submissions = submissions.select(&:incomplete?)
      end

      submissions
    end
  end
end
