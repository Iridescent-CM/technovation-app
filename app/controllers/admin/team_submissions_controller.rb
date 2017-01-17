module Admin
  class TeamSubmissionsController < AdminController
    def index
      @team_submissions = Admin::SearchTeamSubmissions.(params)
        .paginate(per_page: params[:per_page], page: params[:page])
    end

    def show
      @team_submission = TeamSubmission.find(params[:id])
    end

    def edit
      @team_submission = TeamSubmission.find(params[:id])
      @team_submission.build_business_plan if @team_submission.business_plan.blank?
    end

    def update
      @team_submission = TeamSubmission.find(params[:id])

      if @team_submission.update_attributes(team_submission_params)
        redirect_to [:admin, @team_submission],
          success: "Saved!"
      else
        render :edit
      end
    end

    private
    def team_submission_params
      params.require(:team_submission).permit(
        :app_name,
        :app_description,
        :stated_goal,
        :stated_goal_explanation,
        :demo_video_link,
        :pitch_video_link,
        :source_code,
        :source_code_external_url,
        :source_code_file_uploaded,
        :development_platform,
        :development_platform_other,
        business_plan_attributes: [
          :id,
          :uploaded_file,
          :remote_file_url,
          :file_uploaded,
        ],
      )
    end
  end
end
