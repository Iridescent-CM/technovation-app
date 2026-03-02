class AddLowestScoreDroppedAtToTeamSubmissions < ActiveRecord::Migration[5.1]
  def change
    add_column :team_submissions, :lowest_score_dropped_at, :datetime
  end
end
