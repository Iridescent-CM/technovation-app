module RegionalAmbassador
  module SearchTeamSubmissions
    def self.call(params, ambassador)
      params[:division] = "all" if params[:division].blank?
      params[:has_name] = "all" if params[:has_name].blank?
      params[:technical_checklist] = "all" if params[:technical_checklist].blank?
      params[:completed] = "all" if params[:completed].blank?
      params[:sdg] = "all" if params[:sdg].blank?

      account_ids = case ambassador.country
                    when "US"
                      Account.where(state_province: ambassador.state_province).pluck(:id)
                    else
                      Account.where(country: ambassador.country).pluck(:id)
                    end

      profile_ids = StudentProfile.where(account_id: account_ids).pluck(:id) +
        MentorProfile.where(account_id: account_ids).pluck(:id)

      submissions = TeamSubmission.joins(team: [:division, :memberships])
        .where("memberships.member_id IN (?)", profile_ids)
        .uniq

      case params[:division]
      when 'all'
      else
        submissions = submissions.where("divisions.name = ?",
                                        Division.names[params[:division]])
      end

      case params[:sdg]
      when 'all'
      when 'not selected'
        submissions = submissions.where("stated_goal IS NULL")
      else
        submissions = submissions.where(stated_goal: TeamSubmission.stated_goals[params[:sdg]])
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
