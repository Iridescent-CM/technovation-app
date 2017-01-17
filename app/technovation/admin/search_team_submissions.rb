module Admin
  module SearchTeamSubmissions
    def self.call(params)
      params[:division] = "all" if params[:division].blank?
      params[:has_name] = "all" if params[:has_name].blank?
      params[:technical_checklist] = "all" if params[:technical_checklist].blank?
      params[:completed] = "all" if params[:completed].blank?

      submissions = TeamSubmission.joins(team: :division)

      case params[:division]
      when 'all'
      else
        submissions = submissions.where("divisions.name = ?",
                                        Division.names[params[:division]])
      end

      case params[:has_name]
      when 'yes'
        submissions = submissions.where("team_submissions.app_name IS NOT NULL")
      when 'no'
        submissions = submissions.where("team_submissions.app_name IS NULL")
      end

      case params[:technical_checklist]
      when 'started'
        submissions.joins(:technical_checklist)
      when 'not started'
        submissions.where(
          "team_submissions.id NOT IN (
             SELECT team_submission_id FROM technical_checklists
           )"
        )
      else
        submissions
      end
    end
  end
end
