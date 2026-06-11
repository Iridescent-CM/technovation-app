class AddApprovedAtToSubmissionScores < ActiveRecord::Migration[5.1]
  def change
    add_column :submission_scores, :approved_at, :datetime
  end
end
