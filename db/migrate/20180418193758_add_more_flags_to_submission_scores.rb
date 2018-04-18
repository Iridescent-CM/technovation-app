class AddMoreFlagsToSubmissionScores < ActiveRecord::Migration[5.1]
  def change
    add_column :submission_scores, :seems_too_low, :boolean, default: false
  end
end
