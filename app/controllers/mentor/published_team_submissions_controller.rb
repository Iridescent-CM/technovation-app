module Mentor
  class PublishedTeamSubmissionsController < MentorController
    def show
      @team_submission = TeamSubmission
        .joins(team: :mentors)
        .where("mentor_profiles.id = ?", current_mentor.id)
        .friendly
        .find(params[:id])
      @team = @team_submission.team
      render "team_submissions/published"
    end
  end
end
