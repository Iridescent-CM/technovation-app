module Mentor
  class DashboardsController < MentorController
    def show
      @teams = current_mentor.teams.current.order("teams.name")
    end

    private
    def create_judge_mentor_on_dashboard
      if current_account.judge_profile.present? and current_account.mentor_profile.nil?
        current_account.create_mentor_profile!({
          school_company_name: current_account.judge_profile.company_name,
          job_title: current_account.judge_profile.job_title,
        })

        flash.now[:success] = t("controllers.mentor.dashboards.show.mentor_profile_created")
      end
    end
  end
end
