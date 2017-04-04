class RenameCounterCacheNameOnTeamSubmissions < ActiveRecord::Migration
  def change
    rename_column :team_submissions, :submission_score_count, :submission_scores_count
  end
end
