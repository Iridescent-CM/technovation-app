module Admin
  class ScreenshotsController < AdminController
    def new
      @team_submission = TeamSubmission.friendly.find(params[:team_submission_id])
      @screenshot = @team_submission.screenshots.build
    end

    def create
      @team_submission = TeamSubmission.friendly.find(params[:team_submission_id])
      if @team_submission.screenshots.create(screenshot_params)
        redirect_to admin_team_submission_path(@team_submission),
          success: "Screenshot has been added"
      else
        redirect_to admin_team_submission_path(@team_submission),
          error: "There was an error processing your request. Please notify the dev team."
      end
    end

    private

    def screenshot_params
      params.require(:screenshot).permit(:image)
    end
  end
end
