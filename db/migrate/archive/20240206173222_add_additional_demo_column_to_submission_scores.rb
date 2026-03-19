class AddAdditionalDemoColumnToSubmissionScores < ActiveRecord::Migration[6.1]
  def change
    add_column :submission_scores, :demo_4, :integer, default: 0
  end
end
