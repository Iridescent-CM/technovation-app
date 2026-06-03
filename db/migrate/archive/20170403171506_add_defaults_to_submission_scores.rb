class AddDefaultsToSubmissionScores < ActiveRecord::Migration[4.2]
  def change
    change_column_default :submission_scores, :sdg_alignment, 0
    change_column_default :submission_scores, :evidence_of_problem, 0
    change_column_default :submission_scores, :problem_addressed, 0
    change_column_default :submission_scores, :app_functional, 0
    change_column_default :submission_scores, :demo_video, 0
    change_column_default :submission_scores, :business_plan_short_term, 0
    change_column_default :submission_scores, :business_plan_long_term, 0
    change_column_default :submission_scores, :market_research, 0
    change_column_default :submission_scores, :viable_business_model, 0
    change_column_default :submission_scores, :problem_clearly_communicated, 0
    change_column_default :submission_scores, :compelling_argument, 0
    change_column_default :submission_scores, :passion_energy, 0
    change_column_default :submission_scores, :pitch_specific, 0
    change_column_default :submission_scores, :business_plan_feasible, 0
    change_column_default :submission_scores, :submission_thought_out, 0
    change_column_default :submission_scores, :cohesive_story, 0
    change_column_default :submission_scores, :solution_originality, 0
    change_column_default :submission_scores, :solution_stands_out, 0
  end
end
