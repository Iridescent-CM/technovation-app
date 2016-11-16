module Student
  class ScreenshotsController < StudentController
    def destroy
      screenshot = Screenshot.find(params[:id])

      if current_team.current_team_submission.screenshots.include?(screenshot)
        screenshot.destroy
        head 200
      else
        head 403
      end
    end
  end
end
