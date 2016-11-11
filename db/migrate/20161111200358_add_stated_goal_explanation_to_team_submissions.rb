class AddStatedGoalExplanationToTeamSubmissions < ActiveRecord::Migration
  def change
    add_column :team_submissions, :stated_goal_explanation, :text
  end
end
