module Mentor
  class TeamSubmissionFileUploadConfirmationsController < MentorController
    def show
      job = ProcessUploadJob.perform_later(
        current_team.submission.id,
        "TeamSubmission",
        "source_code",
        params.fetch(:key),
        current_profile.account.id
      )

      flash.now[:success] = t("controllers.teams.show.file_processing")
      @unprocessed_file_url = "//s3.amazonaws.com/#{params[:bucket]}/#{params[:key]}"
      @job = Job.find_by!(job_id: job.job_id)

      render "student/team_submission_file_upload_confirmations/show"
    end
  end
end
