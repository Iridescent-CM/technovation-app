class AddCommentsToSubmissionScores < ActiveRecord::Migration
  def change
    add_column :submission_scores, :ideation_comment, :text
    add_column :submission_scores, :technical_comment, :text
    add_column :submission_scores, :entrepreneurship_comment, :text
    add_column :submission_scores, :pitch_comment, :text
    add_column :submission_scores, :overall_comment, :text
  end
end
