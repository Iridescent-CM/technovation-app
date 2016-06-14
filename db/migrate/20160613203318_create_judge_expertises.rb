class CreateJudgeExpertises < ActiveRecord::Migration
  def change
    create_table :judge_expertises do |t|
      t.references :judging_enabled_user_role, index: true, null: false
      t.references :expertise, index: true, null: false

      t.foreign_key :score_categories, column: :expertise_id
      t.foreign_key :user_roles, column: :judging_enabled_user_role_id

      t.timestamps null: false
    end
  end
end
