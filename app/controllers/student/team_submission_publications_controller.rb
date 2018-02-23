module Student
  class TeamSubmissionPublicationsController < StudentController
    def create
      submission = current_team.submission
      submission.publish!

      redirect_to [
        current_scope,
        :published_submission_confirmation,
        team_id: submission.team_id,
      ],
       success: "Your submission has been entered for judging!"
    end
  end
end
