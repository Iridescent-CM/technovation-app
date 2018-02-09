class AddSurveyToJudgeProfiles < ActiveRecord::Migration[5.1]
  def change
    add_column :judge_profiles, :industry, :integer
    add_column :judge_profiles, :industry_other, :string
    add_column :judge_profiles, :skills, :string
    add_column :judge_profiles, :degree, :string
    add_column :judge_profiles, :join_virtual, :boolean
    add_column :judge_profiles, :survey_completed, :boolean
  end
end
