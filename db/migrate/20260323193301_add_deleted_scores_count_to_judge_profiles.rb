class AddDeletedScoresCountToJudgeProfiles < ActiveRecord::Migration[7.0]
  def self.up
    add_column :judge_profiles, :deleted_scores_count, :integer, null: false, default: 0
  end

  def self.down
    remove_column :judge_profiles, :deleted_scores_count
  end
end
