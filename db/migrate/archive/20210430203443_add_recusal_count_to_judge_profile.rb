class AddRecusalCountToJudgeProfile < ActiveRecord::Migration[5.2]
  def change
    add_column :judge_profiles, :recusal_scores_count, :integer, default: 0, null: false
    add_index :judge_profiles, :recusal_scores_count

    reversible do |direction|
      direction.up do
        execute <<-SQL.squish
          update judge_profiles
            set recusal_scores_count = (
              select count(1)
              from submission_scores
              WHERE submission_scores.judge_profile_id = judge_profiles.id
                and judge_recusal = true
                and '2021' = any(seasons)
            )
        SQL
      end
    end
  end
end
