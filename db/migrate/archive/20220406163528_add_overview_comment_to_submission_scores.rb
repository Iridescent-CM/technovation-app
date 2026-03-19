class AddOverviewCommentToSubmissionScores < ActiveRecord::Migration[6.1]
  def change
    add_column :submission_scores, :overview_comment, :text
    add_column :submission_scores, :overview_comment_word_count, :integer, default: 0
  end
end
