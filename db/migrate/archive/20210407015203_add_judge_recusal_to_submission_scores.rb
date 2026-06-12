class AddJudgeRecusalToSubmissionScores < ActiveRecord::Migration[5.2]
  def up
    execute <<-SQL
      CREATE TYPE judge_recusal_from_submission_reason AS ENUM ('submission_not_in_english', 'knows_team', 'other');
    SQL

    add_column :submission_scores, :judge_recusal, :boolean, null: false, default: false
    add_column :submission_scores, :judge_recusal_reason, :judge_recusal_from_submission_reason
    add_column :submission_scores, :judge_recusal_comment, :string

    add_index :submission_scores, :judge_recusal
  end

  def down
    remove_index :submission_scores, :judge_recusal

    remove_column :submission_scores, :judge_recusal
    remove_column :submission_scores, :judge_recusal_reason
    remove_column :submission_scores, :judge_recusal_comment

    execute <<-SQL
      DROP TYPE judge_recusal_from_submission_reason;
    SQL
  end
end
