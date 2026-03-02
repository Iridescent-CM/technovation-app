class AddAverageScoreToTeamSubmissions < ActiveRecord::Migration[5.0]
  def change
    add_column :team_submissions, :average_score, :decimal, precision: 5, scale: 2, null: false, default: 0.0
    add_index :team_submissions, :average_score
  end
end
