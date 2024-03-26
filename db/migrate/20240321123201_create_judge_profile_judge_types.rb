class CreateJudgeProfileJudgeTypes < ActiveRecord::Migration[6.1]
  def change
    create_table :judge_profile_judge_types do |t|
      t.references :judge_profile, foreign_key: true
      t.references :judge_type, foreign_key: true

      t.timestamps
    end
  end
end
