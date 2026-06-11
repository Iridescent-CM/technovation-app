class UpdateJudgeScoreCounters < ActiveRecord::Migration[5.1]
  def change
    rename_column :judge_profiles, :current_round_scores_count, :quarterfinals_scores_count
    add_column :judge_profiles, :semifinals_scores_count, :integer, default: 0
  end
end
