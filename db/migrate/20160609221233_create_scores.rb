class CreateScores < ActiveRecord::Migration
  def change
    create_table :scores do |t|
      t.references :submission, foreign_key: true, index: true, null: false
      t.references :judge, index: true, null: false
      t.foreign_key :authentication_roles, column: :judge_id

      t.timestamps null: false
    end
  end
end
