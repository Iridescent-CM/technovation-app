module Admin
  module SearchTeamSubmissions
    def self.call(params)
      params[:division] = "all" if params[:division].blank?
      params[:rank] = "all" if params[:rank].blank?

      submissions = TeamSubmission.joins(team: :division)

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

      case params[:rank]
      when 'all'
      else
        submissions = submissions.public_send(params[:rank])
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
