class ConvertGameResponsesToHungerFoodWasteResponsesFor2023Submissions < ActiveRecord::Migration[6.1]
  def up
    TeamSubmission.where(seasons: [2023]).where.not(game: nil).find_each do |team_submission|
      team_submission.solves_hunger_or_food_waste = team_submission.game
      team_submission.solves_hunger_or_food_waste_description = team_submission.game_description
      team_submission.game = nil
      team_submission.game_description = nil

      team_submission.save

      puts "Updated submission: #{team_submission.id} #{team_submission.app_name}"
    end
  end

  def down
    TeamSubmission.where(seasons: [2023]).where.not(solves_hunger_or_food_waste: nil).find_each do |team_submission|
      team_submission.game = team_submission.solves_hunger_or_food_waste
      team_submission.game_description = team_submission.solves_hunger_or_food_waste_description
      team_submission.solves_hunger_or_food_waste = nil
      team_submission.solves_hunger_or_food_waste_description = nil

      team_submission.save

      puts "Updated submission: #{team_submission.id} #{team_submission.app_name}"
    end
  end
end
