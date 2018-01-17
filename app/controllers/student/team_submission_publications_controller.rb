module Student
  class TeamSubmissionPublicationsController < StudentController
    def create
      submission = current_team.submission
      submission.publish!

      redirect_to student_published_team_submission_path(submission),
       success: "Your submission has been entered for judging!"
    end
  end
end
