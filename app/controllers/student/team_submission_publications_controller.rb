module Student
  class TeamSubmissionPublicationsController < StudentController
    def create
      submission = current_team.submission
      submission.publish!

      redirect_to send(
        "#{current_scope}_published_submission_confirmation_path",
        team_id: submission.team_id
      ),
        success: "Your submission has been entered for judging!"
    end
  end
end
