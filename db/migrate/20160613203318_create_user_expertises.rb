class CreateUserExpertises < ActiveRecord::Migration
  def change
    create_table :user_expertises do |t|
      t.references :user, index: true, foreign_key: true, null: false
      t.references :expertise, index: true, null: false
      t.foreign_key :score_categories, column: :expertise_id

      t.timestamps null: false
    end
  end
end
