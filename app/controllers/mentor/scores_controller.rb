module Mentor
  class ScoresController < MentorController
    def show
      @teams = current_mentor.teams.current
      @score = available_scores(params[:id])
    end

    def available_scores(id)
      available =[]
      @teams.each do|team|
        available.push(team.submission.submission_scores.complete)
      end
      score = available.find(id)
      return score
    end
  end
end
