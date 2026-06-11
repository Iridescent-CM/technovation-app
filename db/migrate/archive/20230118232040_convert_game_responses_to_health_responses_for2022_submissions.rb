class ConvertGameResponsesToHealthResponsesFor2022Submissions < ActiveRecord::Migration[6.1]
  def up
    TeamSubmission.where(seasons: [2022]).where.not(game: nil).find_each do |team_submission|
      solves_health_problem = team_submission.game
      solves_health_problem_description = team_submission.game_description

      team_submission.update_columns(
        solves_health_problem: solves_health_problem,
        solves_health_problem_description: solves_health_problem_description,
        game: nil,
        game_description: nil
      )

      puts "Updated submission: #{team_submission.id} #{team_submission.app_name}"
    end
  end

  def down
    # NOOP
  end
end
