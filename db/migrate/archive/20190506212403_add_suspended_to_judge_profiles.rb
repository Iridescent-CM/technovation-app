class AddSuspendedToJudgeProfiles < ActiveRecord::Migration[5.1]
  def change
    add_column :judge_profiles, :suspended, :boolean, default: false
  end
end
