class AddJudgeRecusalCountToTeamSubmissions < ActiveRecord::Migration[5.2]
  def change
    add_column :team_submissions, :judge_recusal_count, :integer, default: 0, null: false
    add_index :team_submissions, :judge_recusal_count

    reversible do |direction|
      direction.up do
        execute <<-SQL.squish
          update team_submissions
            set judge_recusal_count = (
              select count(1)
              from submission_scores
              where submission_scores.team_submission_id = team_submissions.id
              and judge_recusal = true
            )
          where '2021' = any(seasons)
        SQL
      end
    end
  end
end
