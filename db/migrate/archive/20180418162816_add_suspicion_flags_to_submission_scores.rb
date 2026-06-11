class AddSuspicionFlagsToSubmissionScores < ActiveRecord::Migration[5.1]
  def change
    add_column :submission_scores, :completed_too_fast, :boolean, default: false
    add_column :submission_scores, :completed_too_fast_repeat_offense, :boolean, default: false
  end
end
