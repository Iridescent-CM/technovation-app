module Student
  class TeamSubmissionFileUploadConfirmationsController < StudentController
    def show
      ProcessUploadJob.perform_later(current_team.submission, params.fetch(:file_attribute),  params.fetch(:key))
      flash.now[:success] = t("controllers.teams.show.file_processing")
      @unprocessed_file_url = "//s3.amazonaws.com/#{params[:bucket]}/#{params[:key]}"
    end
  end
end
