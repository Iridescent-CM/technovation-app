module Student
  class TeamSubmissionScreenshotUploadConfirmationsController < StudentController
    def show
      ProcessScreenshotsJob.perform_later(current_team.submission, params.fetch(:key))
      flash.now[:success] = t("controllers.teams.show.image_processing")
      @unprocessed_photo_url = "//s3.amazonaws.com/#{params[:bucket]}/#{params[:key]}"
      render template: "student/team_photo_upload_confirmations/show"
    end
  end
end
