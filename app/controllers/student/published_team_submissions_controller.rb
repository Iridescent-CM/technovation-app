module Student
  class PublishedTeamSubmissionsController < StudentController
    def show
      @team_submission = current_team.submission
      @team = current_team

      if SeasonToggles.team_submissions_editable? && @team_submission.incomplete?
        flash.now[:notice] = "Please review your submission for accuracy. Then click the Submit button at the bottom of the page to submit your project."
      end
      render "team_submissions/rebrand/published"
    end
  end
end
