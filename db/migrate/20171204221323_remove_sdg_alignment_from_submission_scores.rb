class RemoveSdgAlignmentFromSubmissionScores < ActiveRecord::Migration[5.1]
  def change
    remove_column :submission_scores, :sdg_alignment, :integer
  end
end
