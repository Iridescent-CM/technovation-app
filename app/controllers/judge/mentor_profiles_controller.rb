module Judge
  class MentorProfilesController < JudgeController
    def new
      @expertises = Expertise.all

      @mentor_profile = current_judge.build_mentor_profile(
        school_company_name: current_judge.company_name,
        job_title: current_judge.job_title,
      )
    end

    def create
      @mentor_profile = current_judge.build_mentor_profile(mentor_profile_params)

      if @mentor_profile.save
        redirect_to mentor_dashboard_path,
          success: t("controllers.judge.mentor_profiles.create.success")
      else
        @expertises = Expertise.all
        render :new
      end
    end

    private
    def mentor_profile_params
      params.require(:mentor_profile).permit(
        :school_company_name,
        :job_title,
        :bio,
        :accepting_team_invites,
        :virtual,
        expertise_ids: []
      )
    end
  end
end
