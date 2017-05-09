module Lgeacy
  module V2
    module Admin
      class SubmissionScoreRestorationsController < AdminController
        def update
          submission = TeamSubmission.friendly.find(params[:id])
          submission.submission_scores.deleted.find_each(&:restore)
          redirect_back fallback_location: admin_team_submission_path(submission),
            success: "Scores restored for #{submission.app_name}"
        end
      end
    end
  end
end
