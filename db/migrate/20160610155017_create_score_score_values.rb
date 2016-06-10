class CreateScoreScoreValues < ActiveRecord::Migration
  def change
    create_table :score_values_scores, id: false do |t|
      t.references :score_value, foreign_key: true, index: true, null: false
      t.references :score, foreign_key: true, index: true, null: false
    end
  end
end
