require "will_paginate/array"

module Admin
  class TeamSubmissionsController < AdminController
    def index
      params[:page] = 1 if params[:page].blank?
      params[:per_page] = 15 if params[:per_page].blank?

      @team_submissions = Admin::SearchTeamSubmissions.(params)
        .paginate(page: params[:page].to_i, per_page: params[:per_page].to_i)

      if @team_submissions.empty?
        @team_submissions = @team_submissions.paginate(page: 1)
      end
    end

    def show
      @team_submission = TeamSubmission.friendly.find(params[:id])
      @team_submission.build_technical_checklist if @team_submission.technical_checklist.blank?
    end

    def edit
      @team_submission = TeamSubmission.friendly.find(params[:id])
      @team_submission.build_business_plan if @team_submission.business_plan.blank?
    end

    def update
      @team_submission = TeamSubmission.friendly.find(params[:id])

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
