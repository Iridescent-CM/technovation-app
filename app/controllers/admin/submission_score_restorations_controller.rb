module Admin
  class SubmissionScoreRestorationsController < AdminController
    def update
      submission = TeamSubmission.friendly.find(params[:id])
      submission.submission_scores.find_each(&:restore)
      submission.update_average_scores
      redirect_back fallback_location: admin_team_submission_path(submission),
        success: "Scores restored for #{submission.app_name}"
    end
  end
end
