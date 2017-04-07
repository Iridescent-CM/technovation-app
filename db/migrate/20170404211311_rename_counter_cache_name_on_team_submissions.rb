class RenameCounterCacheNameOnTeamSubmissions < ActiveRecord::Migration[4.2]
  def change
    rename_column :team_submissions, :submission_score_count, :submission_scores_count
  end
end
