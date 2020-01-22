class ChangeJudgingRubricFields < ActiveRecord::Migration[5.1]
  def change
    remove_column :submission_scores, :sdg_alignment, :integer
    remove_column :submission_scores, :evidence_of_problem, :integer
    remove_column :submission_scores, :problem_addressed, :integer
    remove_column :submission_scores, :app_functional, :integer
    remove_column :submission_scores, :demo, :integer
    remove_column :submission_scores, :problem_clearly_communicated, :integer
    remove_column :submission_scores, :compelling_argument, :integer
    remove_column :submission_scores, :passion_energy, :integer
    remove_column :submission_scores, :pitch_specific, :integer
    remove_column :submission_scores, :viable_business_model, :integer
    remove_column :submission_scores, :market_research, :integer
    remove_column :submission_scores, :business_plan_long_term, :integer
    remove_column :submission_scores, :business_plan_short_term, :integer
    remove_column :submission_scores, :business_plan_feasible, :integer
    remove_column :submission_scores, :submission_thought_out, :integer
    remove_column :submission_scores, :cohesive_story, :integer
    remove_column :submission_scores, :solution_originality, :integer
    remove_column :submission_scores, :solution_stands_out, :integer

    add_column :submission_scores, :ideation_1, :integer, default: 0
    add_column :submission_scores, :ideation_2, :integer, default: 0
    add_column :submission_scores, :ideation_3, :integer, default: 0
    add_column :submission_scores, :ideation_4, :integer, default: 0
    add_column :submission_scores, :technical_1, :integer, default: 0
    add_column :submission_scores, :technical_2, :integer, default: 0
    add_column :submission_scores, :technical_3, :integer, default: 0
    add_column :submission_scores, :technical_4, :integer, default: 0
    add_column :submission_scores, :pitch_1, :integer, default: 0
    add_column :submission_scores, :pitch_2, :integer, default: 0
    add_column :submission_scores, :entrepreneurship_1, :integer, default: 0
    add_column :submission_scores, :entrepreneurship_2, :integer, default: 0
    add_column :submission_scores, :entrepreneurship_3, :integer, default: 0
    add_column :submission_scores, :entrepreneurship_4, :integer, default: 0
    add_column :submission_scores, :overall_1, :integer, default: 0
    add_column :submission_scores, :overall_2, :integer, default: 0
  end
end
