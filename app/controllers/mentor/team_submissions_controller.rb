module Mentor
  class TeamSubmissionsController < MentorController
    before_action :require_onboarded

    def new
      team = Team.find(params[:team_id])
      @team_submission = team.team_submissions.build
    end

    def create
      @team_submission = TeamSubmission.new(team_submission_params)

      if @team_submission.save
        redirect_to mentor_team_submission_path(@team_submission),
          success: t("controllers.team_submissions.create.success")
      else
        render :new
      end
    end

    def show
      @team_submission = TeamSubmission.friendly.find(params[:id])
      @team = @team_submission.team

      unless @team_submission.pitch_presentation.present?
        @team_submission.build_pitch_presentation
      end

      if SeasonToggles.team_submissions_editable?
        render 'edit'
      else
        render 'show'
      end
    end

    def edit
      @team_submission = TeamSubmission.friendly.find(params[:id])
      @team = @team_submission.team

      if params[:attributes]
        JSON.parse(params[:attributes]).each do |k, v|
          @team_submission.public_send("#{k}=", v)
        end

        @team_submission.valid?
      end

      @team_submission.screenshots.build

      unless @team_submission.business_plan.present?
        @team_submission.build_business_plan
      end

      unless @team_submission.pitch_presentation.present?
        @team_submission.build_pitch_presentation
      end

      if @team_submission.present?
        begin
          render "team_submissions/pieces/#{params.fetch(:piece)}"
        rescue ActionView::MissingTemplate, ActionController::ParameterMissing
          redirect_to mentor_team_submission_path(@team_submission)
        end
      else
        redirect_to new_mentor_team_submission_path
      end
    end


    def update
      @team_submission = TeamSubmission.friendly.find(params[:id])

      if team_submission_params[:screenshots]
        team_submission_params[:screenshots].each_with_index do |id, index|
          screenshot = @team_submission.screenshots.find(id)
          screenshot.update_attributes(sort_position: index)
        end

        head 200
      elsif @team_submission.update(team_submission_params)
        if request.xhr?
          render json: {}
        else
          redirect_to [:mentor, @team_submission],
            success: t("controllers.team_submissions.update.success")
        end
      else
        redirect_to edit_mentor_team_submission_path(
          @team_submission,
          piece: params[:piece],
          attributes: @team_submission.attributes.to_json,
        )
      end
    end

    private
    def require_onboarded
      if current_mentor.onboarded?
        true
      else
        redirect_to mentor_dashboard_path,
          notice: t("controllers.application.onboarding_required")
      end
    end

    def team_submission_params
      if SeasonToggles.team_submissions_editable?
        params.require(:team_submission).permit(
          :team_id,
          :integrity_affirmed,
          :source_code,
          :app_description,
          :app_name,
          :demo_video_link,
          :pitch_video_link,
          :development_platform_other,
          :development_platform,
          :app_inventor_app_name,
          :app_inventor_gmail,
          screenshots: [],
          screenshots_attributes: [
            :id,
            :image,
          ],
          business_plan_attributes: [
            :id,
            :uploaded_file,
          ],
          pitch_presentation_attributes: [
            :id,
            :uploaded_file,
          ],
        )
      else
        params.require(:team_submission).permit(
          pitch_presentation_attributes: [
            :id,
            :remote_file_url,
          ],
        )
      end
    end
  end
end
