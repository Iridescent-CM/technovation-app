class CreateJudgeProfiles < ActiveRecord::Migration
  def change
    create_table :judge_profiles do |t|
      t.integer :authentication_id, foreign_key: true, index: true, null: false
      t.string :company_name, null: false
      t.string :job_title, null: false

      t.timestamps null: false
    end
  end
end
