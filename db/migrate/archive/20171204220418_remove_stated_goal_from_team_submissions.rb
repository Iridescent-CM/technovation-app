class RemoveStatedGoalFromTeamSubmissions < ActiveRecord::Migration[5.1]
  def change
    remove_column :team_submissions, :stated_goal, :integer
    remove_column :team_submissions, :stated_goal_explanation, :text
  end
end
