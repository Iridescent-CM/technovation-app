class UpdateCounterCacheColumnsOnTeamSubmissions < ActiveRecord::Migration[5.1]
  def change
    rename_column :team_submissions,
      :quarterfinals_official_submission_scores_count,
      :complete_quarterfinals_official_submission_scores_count

    rename_column :team_submissions,
      :semifinals_official_submission_scores_count,
      :complete_semifinals_official_submission_scores_count

    rename_column :team_submissions,
      :semifinals_submission_scores_count,
      :complete_semifinals_submission_scores_count

    rename_column :team_submissions,
      :quarterfinals_submission_scores_count,
      :complete_quarterfinals_submission_scores_count

    add_column :team_submissions,
      :pending_semifinals_submission_scores_count,
      :integer, null: false, default: 0

    add_column :team_submissions,
      :pending_quarterfinals_submission_scores_count,
      :integer, null: false, default: 0

    add_column :team_submissions,
      :pending_semifinals_official_submission_scores_count,
      :integer, null: false, default: 0

    add_column :team_submissions,
      :pending_quarterfinals_official_submission_scores_count,
      :integer, null: false, default: 0
  end
end
