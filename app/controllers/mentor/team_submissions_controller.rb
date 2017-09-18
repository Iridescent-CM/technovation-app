module Mentor
  class TeamSubmissionsController < MentorController
    before_action :require_onboarded

    def new
      @team_submission = if current_team.submission.present?
                           current_team.submission
                         else
                           current_team.team_submissions.build
                         end

      render 'student/team_submissions/new'
    end

    def create
      @team_submission = if current_team.submission.present?
                           current_team.submission
                         else
                            current_team.team_submissions.build(
                              team_submission_params
                            )
                         end

      if @team_submission.save
        redirect_to mentor_team_submission_path(
          @team_submission,
          team_id: current_team.id
        ),
        success: t("controllers.team_submissions.create.success")
      else
        render 'student/team_submissions/new'
      end
    end

    def show
      @team_submission = TeamSubmission.friendly.find(params[:id])
      params[:team_id] = @team_submission.team_id

      unless @team_submission.pitch_presentation.present?
        @team_submission.build_pitch_presentation
      end

      @pitch_presentation_uploader = FileUploader.new
      @pitch_presentation_uploader.success_action_redirect =
        student_team_submission_file_upload_confirmation_url(
          file_attribute: :pitch_presentation,
          back: student_team_submission_path(@team_submission)
        )

      if SeasonToggles.team_submissions_editable?
        unless @team_submission.business_plan
          @team_submission.build_business_plan
        end

        @business_plan_uploader = FileUploader.new
        @business_plan_uploader.success_action_redirect =
          student_team_submission_file_upload_confirmation_url(
            file_attribute: :business_plan,
            back: student_team_submission_path(@team_submission)
          )


        @source_code_uploader = FileUploader.new
        @source_code_uploader.success_action_redirect =
          student_team_submission_file_upload_confirmation_url(
            file_attribute: :source_code,
            back: student_team_submission_path(@team_submission)
          )

        @team_photo_uploader = ImageUploader.new
        @team_photo_uploader.success_action_redirect =
          student_team_photo_upload_confirmation_url(back: request.fullpath)

        @screenshots_uploader = ImageUploader.new
        @screenshots_uploader.success_action_redirect = ''

        render 'student/team_submissions/edit'
      else
        render 'student/team_submissions/show'
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
      elsif @team_submission.update_attributes(team_submission_params)
        if request.xhr?
          render json: {
            pitch_embed: @team_submission.embed_code(:pitch_video_link),
            demo_embed: @team_submission.embed_code(:demo_video_link),
          }
        else
          redirect_to mentor_team_submission_path(
            @team_submission,
            team_id: @team_submission.team_id
          ),
            success: t("controllers.team_submissions.update.success")
        end
      else
        render 'student/team_submissions/new'
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
      sub_params = if SeasonToggles.team_submissions_editable?
                    params.require(:team_submission).permit(
                      :integrity_affirmed,
                      :source_code,
                      :source_code_external_url,
                      :app_description,
                      :stated_goal,
                      :stated_goal_explanation,
                      :app_name,
                      :demo_video_link,
                      :pitch_video_link,
                      :development_platform_other,
                      :development_platform,
                      :source_code_file_uploaded,
                      business_plan_attributes: [
                        :id,
                        :remote_file_url,
                      ],
                      pitch_presentation_attributes: [
                        :id,
                        :remote_file_url,
                      ],
                      screenshots: [],
                    )
                   else
                    params.require(:team_submission).permit(
                      pitch_presentation_attributes: [
                        :id,
                        :remote_file_url,
                      ],
                    )
                   end
      sub_params.tap do |tapped|
        if tapped[:pitch_presentation_attributes]
          tapped[:pitch_presentation_attributes][:file_uploaded] = false
        end

        unless tapped[:source_code_external_url].blank?
          tapped[:source_code_file_uploaded] = false
        end

        if tapped[:business_plan_attributes]
          tapped[:business_plan_attributes][:file_uploaded] = false
        end
      end
    end
  end
end
