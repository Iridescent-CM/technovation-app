class CreateScoreCategories < ActiveRecord::Migration
  def change
    create_table :score_categories do |t|
      t.string :name, null: false
      t.boolean :is_expertise, null: false, default: false

      t.timestamps null: false
    end
  end
end
