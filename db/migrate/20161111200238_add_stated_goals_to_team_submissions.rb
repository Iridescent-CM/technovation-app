class AddStatedGoalsToTeamSubmissions < ActiveRecord::Migration
  def change
    add_column :team_submissions, :stated_goal, :integer
    add_index :team_submissions, :stated_goal
  end
end
