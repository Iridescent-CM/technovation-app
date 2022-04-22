module Admin
  class TeamSubmissionsController < AdminController
    include DatagridController

    use_datagrid with: SubmissionsGrid

    def show
      @team_submission = TeamSubmission.friendly.find(params[:id])
    end

    def edit
      @team_submission = TeamSubmission.friendly.find(params[:id])
    end

    def update
      @team_submission = TeamSubmission.friendly.find(params[:id])

      if @team_submission.update(team_submission_params)
        redirect_to admin_team_submission_path,
        success: "Submission has been updated"
      else
        render :edit
      end
    end

    private
    def grid_params
      grid = (params[:submissions_grid] ||= {}).merge(
        admin: true,
        country: Array(params[:submissions_grid][:country]),
        state_province: Array(params[:submissions_grid][:state_province]),
        season: params[:submissions_grid][:season] || Season.current.year,
      )

      grid.merge(
        column_names: detect_extra_columns(grid),
      )
    end

    def team_submission_params
      params.require(:team_submission).permit(
        :app_name,
        :app_description,
        :pitch_video_link,
        :demo_video_link,
        :business_plan,
        :development_platform,
        :app_inventor_app_name,
        :learning_journey,
        :submission_type,
        :app_inventor_gmail,
        :source_code,
        :contest_rank,
        :business_plan_cache,
        :development_platform_other,
        :source_code_cache,
        :thunkable_project_url,
        :thunkable_account_email
      )
    end
  end
end
