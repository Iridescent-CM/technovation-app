module Mentor
  class TeamPhotoUploadConfirmationsController < MentorController
    def show
      ProcessUploadJob.perform_later(current_team.id, Team, "team_photo", params.fetch(:key))
      flash.now[:success] = t("controllers.teams.show.image_processing")
      @unprocessed_photo_url = "//s3.amazonaws.com/#{params[:bucket]}/#{params[:key]}"
      render template: "student/team_photo_upload_confirmations/show"
    end
  end
end
