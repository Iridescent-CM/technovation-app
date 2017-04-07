class AddStatedGoalExplanationToTeamSubmissions < ActiveRecord::Migration[4.2]
  def change
    add_column :team_submissions, :stated_goal_explanation, :text
  end
end
