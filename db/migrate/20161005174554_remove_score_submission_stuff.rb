class RemoveScoreSubmissionStuff < ActiveRecord::Migration
  def up
    drop_table :judge_scoring_expertises
    drop_table :scored_values
    drop_table :score_values
    drop_table :score_questions
    drop_table :score_categories
    drop_table :scores
    drop_table :submissions
  end
end
