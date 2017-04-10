class SubmissionScore < ActiveRecord::Base
  before_destroy -> {
    if incomplete?
      team_submission.clear_judge_opened_details!
    end
  }

  belongs_to :team_submission, counter_cache: true
  belongs_to :judge_profile

  scope :complete, -> { where("completed_at IS NOT NULL") }
  scope :incomplete, -> { where("completed_at IS NULL") }

  validates :team_submission_id, uniqueness: { scope: :judge_profile_id }

  delegate :app_name,
           :team_photo,
           :team_name,
           :team_division_name,
           :team_primary_location,
           :team_ages,
    to: :team_submission,
    prefix: true,
    allow_nil: false

  delegate :team,
    to: :team_submission,
    prefix: false,
    allow_nil: false

  def name
    [team_submission_app_name,
     team_submission_team_name].join(' by ')
  end

  def complete?
    not attributes.reject { |k, _| k == 'completed_at' }.values.any?(&:blank?)
  end

  def incomplete?
    not complete?
  end

  def complete!
    self.completed_at = Time.current
    team_submission.clear_judge_opened_details!
    save!
  end

  def team_submission_stated_goal
    team_submission.stated_goal || "No goal selected!"
  end

  def senior_team_division?
    team_submission.team.division.senior?
  end

  def total
    ideation_total +
      technical_total +
        entrepreneurship_total +
          pitch_total +
            overall_impression_total
  end

  def ideation_total
    sdg_alignment +
      evidence_of_problem +
        problem_addressed
  end

  def technical_total
    app_functional +
      demo_video +
        team_submission.total_technical_checklist_verified
  end

  def entrepreneurship_total
    business_plan_short_term +
      business_plan_long_term +
        market_research +
          viable_business_model
  end

  def pitch_total
    problem_clearly_communicated +
      compelling_argument +
        passion_energy +
          pitch_specific
  end

  def overall_impression_total
    business_plan_feasible +
      submission_thought_out +
        cohesive_story +
          solution_originality +
            solution_stands_out
  end


  def total_possible
    case team_submission.team_division_name
    when "junior"
      80
    when "senior"
      100
    else
      0
    end
  end
end
