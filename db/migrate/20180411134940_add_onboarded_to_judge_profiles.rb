class AddOnboardedToJudgeProfiles < ActiveRecord::Migration[5.1]
  def up
    add_column :judge_profiles, :onboarded, :boolean, default: false
    JudgeProfile.current.find_each(&:touch)
  end

  def down
    remove_column :judge_profiles, :onboarded
  end
end
