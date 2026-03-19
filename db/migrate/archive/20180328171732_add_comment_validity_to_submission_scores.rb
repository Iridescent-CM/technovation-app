class AddCommentValidityToSubmissionScores < ActiveRecord::Migration[5.1]
  def change
    add_column :submission_scores, :ideation_comment_positivity,
      :decimal, precision: 4, scale: 3, default: 0
    add_column :submission_scores, :ideation_comment_negativity,
      :decimal, precision: 4, scale: 3, default: 0
    add_column :submission_scores, :ideation_comment_neutrality,
      :decimal, precision: 4, scale: 3, default: 0
    add_column :submission_scores, :ideation_comment_word_count,
      :integer, default: 0
    add_column :submission_scores, :ideation_comment_bad_word_count,
      :integer, default: 0

    add_column :submission_scores, :technical_comment_positivity,
      :decimal, precision: 4, scale: 3, default: 0
    add_column :submission_scores, :technical_comment_negativity,
      :decimal, precision: 4, scale: 3, default: 0
    add_column :submission_scores, :technical_comment_neutrality,
      :decimal, precision: 4, scale: 3, default: 0
    add_column :submission_scores, :technical_comment_word_count,
      :integer, default: 0
    add_column :submission_scores, :technical_comment_bad_word_count,
      :integer, default: 0

    add_column :submission_scores, :pitch_comment_positivity,
      :decimal, precision: 4, scale: 3, default: 0
    add_column :submission_scores, :pitch_comment_negativity,
      :decimal, precision: 4, scale: 3, default: 0
    add_column :submission_scores, :pitch_comment_neutrality,
      :decimal, precision: 4, scale: 3, default: 0
    add_column :submission_scores, :pitch_comment_word_count,
      :integer, default: 0
    add_column :submission_scores, :pitch_comment_bad_word_count,
      :integer, default: 0

    add_column :submission_scores, :entrepreneurship_comment_positivity,
      :decimal, precision: 4, scale: 3, default: 0
    add_column :submission_scores, :entrepreneurship_comment_negativity,
      :decimal, precision: 4, scale: 3, default: 0
    add_column :submission_scores, :entrepreneurship_comment_neutrality,
      :decimal, precision: 4, scale: 3, default: 0
    add_column :submission_scores, :entrepreneurship_comment_word_count,
      :integer, default: 0
    add_column :submission_scores,
      :entrepreneurship_comment_bad_word_count,
      :integer,
      default: 0

    add_column :submission_scores, :overall_comment_positivity,
      :decimal, precision: 4, scale: 3, default: 0
    add_column :submission_scores, :overall_comment_negativity,
      :decimal, precision: 4, scale: 3, default: 0
    add_column :submission_scores, :overall_comment_neutrality,
      :decimal, precision: 4, scale: 3, default: 0
    add_column :submission_scores, :overall_comment_word_count,
      :integer, default: 0
    add_column :submission_scores, :overall_comment_bad_word_count,
      :integer, default: 0
  end
end
