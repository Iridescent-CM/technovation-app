module Student
  class PublishedTeamSubmissionsController < StudentController
    def show
      @team_submission = current_team.submission
      @team = current_team
      render "team_submissions/rebrand/published"
    end
  end
end
