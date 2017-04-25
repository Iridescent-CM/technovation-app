class SubmissionScore < ActiveRecord::Base
  acts_as_paranoid

  before_destroy -> {
    if incomplete?
      team_submission.clear_judge_opened_details!
    end
  }

  after_commit ->(sub) {
    if !!sub.completed_at
      sub.team_submission.update_average_score
    end
  }

  belongs_to :team_submission, counter_cache: true
  belongs_to :judge_profile

  scope :complete, -> { where("completed_at IS NOT NULL") }
  scope :incomplete, -> { where("completed_at IS NULL") }

  validates :team_submission_id, presence: true, uniqueness: { scope: :judge_profile_id }

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
    not attributes.reject { |k, _|
      k.match(/_at$/) or
        k == 'event_type' or
          k.match(/_verified$/)
    }.values.any?(&:blank?)
  end

  def incomplete?
    not complete?
  end

  def complete!
    update_attributes(completed_at: Time.current)
    team_submission.clear_judge_opened_details!
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
        total_technical_checklist_verified
  end

  def total_technical_checklist_verified
    if team_submission.technical_checklist
      total_verified
    else
      0
    end
  end

  def total_technical_checklist
    total_technical_checklist_verified
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

  def status
    if !!completed_at
      'complete'
    else
      'pending'
    end
  end

  private
  def total_verified
    total_coding_verified +
      total_db_verified +
        total_mobile_verified +
          total_process_verified
  end

  def total_coding_verified
    calculate_total_verified(
      team_submission.technical_checklist.technical_components,
      points_each: 1,
      points_max:  4
    )
  end

  def total_db_verified
    calculate_total_verified(
      team_submission.technical_checklist.database_components,
      points_each: 1,
      points_max: 1
    )
  end

  def total_mobile_verified
    calculate_total_verified(
      team_submission.technical_checklist.mobile_components,
      points_each: 2,
      points_max: 2
    )
  end

  def total_process_verified
    if team_submission.technical_checklist.pics_of_process.all? { |a|
         team_submission.technical_checklist.send(a).present?
       } and team_submission.screenshots.count >= 2
      3
    else
      0
    end
  end

  def calculate_total_verified(components, options)
    components.reduce(0) do |sum, aspect|
      if sum == options[:points_max]
        sum
      elsif team_submission.technical_checklist.send(aspect) and
          not team_submission.technical_checklist.send("#{aspect}_explanation").blank?
        sum += options[:points_each]
      else
        sum
      end
    end
  end
end
