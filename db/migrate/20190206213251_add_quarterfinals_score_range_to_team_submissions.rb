class AddQuarterfinalsScoreRangeToTeamSubmissions < ActiveRecord::Migration[5.1]
  def change
    add_column :team_submissions, :quarterfinals_score_range, :integer, default: 0
  end
end
