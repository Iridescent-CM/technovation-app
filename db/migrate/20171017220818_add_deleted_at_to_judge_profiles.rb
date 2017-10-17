class AddDeletedAtToJudgeProfiles < ActiveRecord::Migration[5.1]
  def change
    add_column :judge_profiles, :deleted_at, :datetime
  end
end
