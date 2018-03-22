class SetDefaultSdgAlignmentOnSubmissionScores < ActiveRecord::Migration[5.1]
  def up
    change_column_default :submission_scores, :sdg_alignment, 0
  end
end
