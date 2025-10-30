module Mentor
  class ScoresController < MentorController

    def index
      @current_teams = current_mentor.teams.current.order("teams.name")
    end

    def show
      submission_ids = TeamSubmission.where(team_id: current_mentor.teams.pluck(:id))
      @score = SubmissionScore.where(team_submission_id: submission_ids).find(params[:id])
      @team = @score.team
      @team_submission = @team.submission
    end
  end
end
