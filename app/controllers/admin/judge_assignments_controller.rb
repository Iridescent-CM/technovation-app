module Admin
  class JudgeAssignmentsController < AdminController
    def create
      submission = TeamSubmission.friendly.find(params[:team_submission_id])
      account = Account.find_by(email: params[:email])
      flash_message = if account.present?
        SubmissionToJudgeAssigner.new(
          submission: submission,
          judge: account.judge_profile
        ).call.message
      else
        {error: "Can't find judge with email #{params[:email]}"}
      end

      redirect_to admin_score_detail_path(submission.id), flash: flash_message
    end
  end
end
