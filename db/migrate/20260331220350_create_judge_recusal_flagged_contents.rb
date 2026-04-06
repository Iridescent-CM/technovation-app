class CreateJudgeRecusalFlaggedContents < ActiveRecord::Migration[7.0]
  def change
    create_table :judge_recusal_flagged_contents do |t|
      t.references :submission_score, null: false, foreign_key: true
      t.integer :name, null: false

      t.timestamps
    end
  end
end
