class AddTechnicalExperienceToJudgeProfiles < ActiveRecord::Migration[7.0]
  def change
    add_column :judge_profiles, :technical_experience_opt_in, :boolean
    add_column :judge_profiles, :ai_experience, :boolean
  end
end
