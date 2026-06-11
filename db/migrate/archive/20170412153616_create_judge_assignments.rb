class CreateJudgeAssignments < ActiveRecord::Migration[4.2]
  def change
    create_table :judge_assignments do |t|
      t.references :team, index: true, foreign_key: true
      t.references :judge_profile, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
