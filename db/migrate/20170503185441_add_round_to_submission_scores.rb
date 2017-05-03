class AddRoundToSubmissionScores < ActiveRecord::Migration[5.1]
  def change
    add_column :submission_scores, :round, :integer, null: false, default: 0
  end
end
