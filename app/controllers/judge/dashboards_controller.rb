module Judge
  class DashboardsController < JudgeController
    private
    def create_mentor_judge_on_dashboard
      if current_account.mentor_profile.present? and current_account.judge_profile.nil?
        current_account.create_judge_profile!({
          company_name: current_account.mentor_profile.school_company_name,
          job_title: current_account.mentor_profile.job_title,
        })
      end
    end
  end
end
