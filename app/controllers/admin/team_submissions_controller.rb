module Admin
  class TeamSubmissionsController < AdminController
    include AdminHelper
    include DatagridController

    before_action :require_super_admin, only: [:unpublish, :bulk_publish]
    before_action :get_submissions_only_needing_to_submit, only: [:bulk_publish]

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
        redirect_to admin_team_submission_path(@team_submission),
          success: "Submission has been updated"
      else
        flash.now[:alert] = if @team_submission.errors.full_messages
          @team_submission.errors.full_messages.join(" , ")
        else
          "There was an error processing your request. Please notify the dev team."
        end
        render :edit
      end
    end

    def unpublish
      team_submission = TeamSubmission.friendly.find(params[:team_submission_id])
      team_submission.unpublish!

      redirect_back fallback_location: admin_team_submission_path(team_submission),
        success: t("controllers.team_submissions.unpublish.success")
    end

    def bulk_publish
      if params[:submission_ids].present?
        published_count = 0

        Array(params[:submission_ids]).each do |submission_id|
          submission = TeamSubmission.friendly.find(submission_id)

          if SubmissionPublisher.new(submission: submission).call.success?
            published_count += 1
          end
        end

        redirect_back fallback_location: admin_team_submissions_path,
          success: "Successfully published #{published_count} submissions"
      end
    end

    private

    def grid_params
      grid = (params[:submissions_grid] ||= {}).merge(
        admin: true,
        country: Array(params[:submissions_grid][:country]),
        state_province: Array(params[:submissions_grid][:state_province]),
        season: params[:submissions_grid][:season] || Season.current.year
      )

      grid.merge(
        column_names: detect_extra_columns(grid)
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
        :ai,
        :ai_description,
        :climate_change,
        :climate_change_description,
        :game,
        :game_description,
        :solves_health_problem,
        :solves_health_problem_description,
        :solves_hunger_or_food_waste,
        :solves_hunger_or_food_waste_description,
        :uses_open_ai,
        :uses_open_ai_description,
        :app_inventor_gmail,
        :source_code,
        :contest_rank,
        :business_plan_cache,
        :development_platform_other,
        :source_code_cache,
        :thunkable_project_url,
        :thunkable_account_email,
        screenshots_attributes: [:id, :_destroy]
      )
    end

    def get_submissions_only_needing_to_submit
      if current_admin.super_admin?
        @submissions_only_needing_to_submit = TeamSubmission.current.select(&:only_needs_to_submit?)
      end
    end
  end
end
