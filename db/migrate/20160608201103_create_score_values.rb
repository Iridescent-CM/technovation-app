class CreateScoreValues < ActiveRecord::Migration
  def change
    create_table :score_values do |t|
      t.references :score_attribute, index: true, foreign_key: true, null: false
      t.integer :value, null: false
      t.text :label, null: false

      t.timestamps null: false
    end
  end
end
