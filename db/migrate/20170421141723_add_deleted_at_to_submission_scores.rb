class AddDeletedAtToSubmissionScores < ActiveRecord::Migration[5.0]
  def change
    add_column :submission_scores, :deleted_at, :datetime
  end
end
