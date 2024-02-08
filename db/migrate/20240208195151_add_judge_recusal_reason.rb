class AddJudgeRecusalReason < ActiveRecord::Migration[6.1]
  def up
    execute <<-SQL
      ALTER TYPE judge_recusal_from_submission_reason ADD VALUE 'content_does_not_belong_to_team' BEFORE 'other'
    SQL
  end

  def down
    # NOOP
  end
end
