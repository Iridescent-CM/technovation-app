class AddAverageScoreToTeamSubmissions < ActiveRecord::Migration[5.0]
  def change
    add_column :team_submissions, :average_score, :integer
    add_index :team_submissions, :average_score
  end
end
