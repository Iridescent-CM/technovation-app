class AddCompletedAtToSubmissionScores < ActiveRecord::Migration[4.2]
  def change
    add_column :submission_scores, :completed_at, :datetime
    add_index :submission_scores, :completed_at
  end
end
