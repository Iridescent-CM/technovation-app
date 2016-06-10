class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.references :score_value, foreign_key: true, index: true, null: false

      # t.references :submission, foreign_key: true, index: true, null: false
      # t.references :judge, foreign_key: true, index: true, null: false

      t.timestamps null: false
    end
  end
end
