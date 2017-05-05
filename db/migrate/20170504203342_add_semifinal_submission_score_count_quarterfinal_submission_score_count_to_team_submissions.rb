class AddSemifinalSubmissionScoreCountQuarterfinalSubmissionScoreCountToTeamSubmissions < ActiveRecord::Migration[5.1]
  def change
    add_column :team_submissions, :semifinals_submission_scores_count, :integer, :null => false, :default => 0
    add_column :team_submissions, :quarterfinals_submission_scores_count, :integer, :null => false, :default => 0
  end
end
