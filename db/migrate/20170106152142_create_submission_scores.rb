class CreateSubmissionScores < ActiveRecord::Migration[4.2]
  def change
    create_table :submission_scores do |t|
      t.references :team_submission, index: true, foreign_key: true
      t.references :judge_profile, index: true, foreign_key: true
      t.integer :sdg_alignment
      t.integer :evidence_of_problem
      t.integer :problem_addressed
      t.integer :app_functional
      t.integer :demo_video
      t.integer :business_plan_short_term
      t.integer :business_plan_long_term
      t.integer :market_research
      t.integer :viable_business_model
      t.integer :problem_clearly_communicated
      t.integer :compelling_argument
      t.integer :passion_energy
      t.integer :pitch_specific
      t.integer :business_plan_feasible
      t.integer :submission_thought_out
      t.integer :cohesive_story
      t.integer :solution_originality
      t.integer :solution_stands_out

      t.timestamps null: false
    end
  end
end
