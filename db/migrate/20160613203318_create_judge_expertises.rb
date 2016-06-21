class CreateJudgeExpertises < ActiveRecord::Migration
  def change
    create_table :judge_expertises do |t|
      t.references :judge_profile, index: true, foreign_key: true, null: false
      t.references :expertise, index: true, null: false

      t.foreign_key :score_categories, column: :expertise_id

      t.timestamps null: false
    end
  end
end
