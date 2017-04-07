class CreateJudgeProfiles < ActiveRecord::Migration[4.2]
  def change
    create_table :judge_profiles do |t|
      t.integer :account_id, foreign_key: true, index: true, null: false
      t.string :company_name, null: false
      t.string :job_title, null: false

      t.timestamps null: false
    end
  end
end
