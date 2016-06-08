class CreateScoreAttributes < ActiveRecord::Migration
  def change
    create_table :score_attributes do |t|
      t.references :score_category, index: true, foreign_key: true, null: false
      t.text :label, null: false

      t.timestamps null: false
    end
  end
end
