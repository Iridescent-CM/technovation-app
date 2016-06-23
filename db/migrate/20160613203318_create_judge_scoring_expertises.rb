class CreateJudgeScoringExpertises < ActiveRecord::Migration
  def change
    create_table :judge_scoring_expertises do |t|
      t.references :judge_profile, index: true, foreign_key: true, null: false
      t.references :scoring_expertise, index: true, null: false

      t.foreign_key :score_categories, column: :scoring_expertise_id

      t.timestamps null: false
    end
  end
end
