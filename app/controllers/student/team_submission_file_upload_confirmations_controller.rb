module Student
  class TeamSubmissionFileUploadConfirmationsController < StudentController
    def show
      job = ProcessUploadJob.perform_later(
        current_team.submission.id,
        'TeamSubmission',
        'source_code',
        params.fetch(:key)
      )

      flash.now[:success] = t("controllers.teams.show.file_processing")
      @unprocessed_file_url = "//s3.amazonaws.com/#{params[:bucket]}/#{params[:key]}"
      @job = Job.find_by!(job_id: job.job_id)
    end
  end
end
