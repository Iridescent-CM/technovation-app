module Student
  class TeamSubmissionSectionsController < StudentController
    def show
      @team_submission = current_team.submission
      @team = current_team

      @uploader = ImageUploader.new
      @uploader.success_action_redirect = send(
        "#{current_scope}_team_photo_upload_confirmation_url",
        team_id: @team.id,
        back: request.fullpath
      )

      render "team_submissions/sections/#{params.fetch(:section)}"
    end
  end
end
