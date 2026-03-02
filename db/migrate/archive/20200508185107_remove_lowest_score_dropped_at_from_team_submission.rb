class RemoveLowestScoreDroppedAtFromTeamSubmission < ActiveRecord::Migration[5.1]
  def change
    remove_column :team_submissions, :lowest_score_dropped_at, :datetime
  end
end
