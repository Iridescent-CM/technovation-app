class AddSemifinalsScoreRangeToTeamSubmissions < ActiveRecord::Migration[5.1]
  def change
    add_column :team_submissions, :semifinals_score_range, :integer, default: 0
  end
end
