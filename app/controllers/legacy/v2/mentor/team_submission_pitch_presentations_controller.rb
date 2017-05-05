module Mentor
  class TeamSubmissionPitchPresentationsController < MentorController
    def new
      do_new
      render 'student/team_submission_pitch_presentations/new'
    end

    def edit
      do_new
      render 'student/team_submission_pitch_presentations/new'
    end

    private
    def do_new
      @submission = current_team.submission

      @submission.build_pitch_presentation unless @submission.pitch_presentation

      @pitch_presentation_uploader = FileUploader.new
      @pitch_presentation_uploader.success_action_redirect = mentor_team_submission_file_upload_confirmation_url(
        team_id: current_team.id,
        file_attribute: :pitch_presentation,
        back: edit_mentor_team_submission_pitch_presentation_path(
          @submission,
          team_id: @submission.team_id
        )
      )
    end
  end
end
