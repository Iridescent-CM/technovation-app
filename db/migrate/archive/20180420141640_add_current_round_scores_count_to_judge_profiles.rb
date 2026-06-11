class AddCurrentRoundScoresCountToJudgeProfiles < ActiveRecord::Migration[5.1]
  def self.up
    add_column :judge_profiles, :current_round_scores_count, :integer, null: false, default: 0
  end

  def self.down
    remove_column :judge_profiles, :current_round_scores_count
  end
end
