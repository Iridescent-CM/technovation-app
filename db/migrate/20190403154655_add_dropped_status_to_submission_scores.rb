class AddDroppedStatusToSubmissionScores < ActiveRecord::Migration[5.1]
  def change
    add_column :submission_scores, :dropped_at, :datetime
  end
end
