class CreateScoredValues < ActiveRecord::Migration
  def change
    create_table :scored_values do |t|
      t.references :score_value, foreign_key: true, index: true, null: false
      t.references :score, foreign_key: true, index: true, null: false
    end
  end
end
