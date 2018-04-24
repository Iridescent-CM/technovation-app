module Mentor
  class TeamSubmissionFileUploadConfirmationsController < MentorController
    def show
      ProcessUploadJob.perform_later(
        current_team.submission.id,
        'TeamSubmission',
        'source_code',
        params.fetch(:key)
      )

      flash.now[:success] = t("controllers.teams.show.file_processing")
      @unprocessed_file_url = "//s3.amazonaws.com/#{params[:bucket]}/#{params[:key]}"

      render 'student/team_submission_file_upload_confirmations/show'
    end
  end
end
