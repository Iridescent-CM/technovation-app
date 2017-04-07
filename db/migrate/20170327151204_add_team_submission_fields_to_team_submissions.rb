class AddTeamSubmissionFieldsToTeamSubmissions < ActiveRecord::Migration[4.2]
  def change
    add_column :team_submissions, :submission_score_count, :integer
    add_index :team_submissions, :submission_score_count
    add_column :team_submissions, :judge_opened_id, :integer
    add_column :team_submissions, :judge_opened_at, :datetime
    add_index :team_submissions, :judge_opened_at
  end
end
