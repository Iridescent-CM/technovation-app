module Mentor
  class ScoresController < MentorController
    def show
      submission_ids = TeamSubmission.where(team_id: current_mentor.teams.pluck(:id))
      @score = SubmissionScore.where(team_submission_id: submission_ids).find(params[:id])

      @division = @score.team_submission.team.division

      render 'student/scores/show'
    end
  end
end
