class AddColumnsToSubmissionScores < ActiveRecord::Migration[6.1]
  def change
    add_column :submission_scores, :overview_1, :integer, default: 0

    add_column :submission_scores, :pitch_3, :integer, default: 0
    add_column :submission_scores, :pitch_4, :integer, default: 0
    add_column :submission_scores, :pitch_5, :integer, default: 0
    add_column :submission_scores, :pitch_6, :integer, default: 0
    add_column :submission_scores, :pitch_7, :integer, default: 0
    add_column :submission_scores, :pitch_8, :integer, default: 0

    add_column :submission_scores, :demo_1, :integer, default: 0
    add_column :submission_scores, :demo_2, :integer, default: 0
    add_column :submission_scores, :demo_3, :integer, default: 0
  end
end
