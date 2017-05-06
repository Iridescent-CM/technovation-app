module Legacy
  module V2
    module Mentor
      class TeamSubmissionsController < MentorController
        before_action :require_full_access

        def new
          params[:step] = :affirm_integrity if params[:step].blank?
          @team_submission = current_team.team_submissions.last ||
            current_team.team_submissions.build(step: params[:step])
          render 'student/team_submissions/new'
        end

        def create
          @team_submission = current_team.team_submissions.last ||
            current_team.team_submissions.build(team_submission_params)

          if @team_submission.save
            redirect_to mentor_team_submission_path(@team_submission, team_id: current_team.id),
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
          @pitch_presentation_uploader.success_action_redirect = mentor_team_submission_file_upload_confirmation_url(
            team_id: @team_submission.team_id,
            file_attribute: :pitch_presentation,
            back: mentor_team_submission_path(@team_submission, team_id: @team_submission.team_id)
          )

          render 'student/team_submissions/show'
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
        def require_full_access
          if current_mentor.full_access_enabled?
            true
          else
            redirect_to mentor_dashboard_path,
              notice: t("controllers.application.full_access_required")
          end
        end

        def team_submission_params
          params.require(:team_submission).permit(
            pitch_presentation_attributes: [
              :id,
              :remote_file_url,
            ],
          ).tap do |tapped|
            if tapped[:pitch_presentation_attributes]
              tapped[:pitch_presentation_attributes][:file_uploaded] = false
            end
          end
        end
      end
    end
  end
end
