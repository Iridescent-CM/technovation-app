class CreateScores < ActiveRecord::Migration
  def change
    create_table :scores do |t|
      t.references :submission, foreign_key: true, index: true, null: false
      t.references :judge_profile, foreign_key: true, index: true, null: false

      t.timestamps null: false
    end
  end
end
