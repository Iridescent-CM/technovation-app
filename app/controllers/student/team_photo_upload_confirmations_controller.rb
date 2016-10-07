module Student
  class TeamPhotoUploadConfirmationsController < StudentController
    def show
      ProcessUploadJob.perform_later(current_team, "team_photo", params.fetch(:key))
      flash.now[:success] = t("controllers.teams.show.image_processing")
      @unprocessed_photo_url = "//s3.amazonaws.com/#{params[:bucket]}/#{params[:key]}"
    end
  end
end
