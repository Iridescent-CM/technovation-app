module Legacy
  module V2
    module Student
      class TeamSubmissionPitchPresentationsController < StudentController
        def new
          do_new
        end

        def edit
          do_new
          render :new
        end

        private
        def do_new
          @submission = current_team.submission

          @submission.build_pitch_presentation unless @submission.pitch_presentation

          @pitch_presentation_uploader = FileUploader.new
          @pitch_presentation_uploader.success_action_redirect = student_team_submission_file_upload_confirmation_url(
            file_attribute: :pitch_presentation,
            back: edit_student_team_submission_pitch_presentation_path(@submission)
          )
        end
      end
    end
  end
end
