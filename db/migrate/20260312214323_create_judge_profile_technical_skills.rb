class CreateJudgeProfileTechnicalSkills < ActiveRecord::Migration[7.0]
  def change
    create_table :judge_profile_technical_skills do |t|
      t.references :judge_profile, null: false, foreign_key: true
      t.references :technical_skill, null: false, foreign_key: true

      t.timestamps
    end
  end
end
