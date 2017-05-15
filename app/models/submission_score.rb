class SubmissionScore < ActiveRecord::Base
  acts_as_paranoid

  before_destroy -> {
    if incomplete?
      team_submission.clear_judge_opened_details!
    end
  }

  after_commit ->(sub) {
    if !!sub.completed_at
      sub.team_submission.update_average_scores
    end
  }

  before_create -> {
    self.event_type ||= judge_profile.selected_regional_pitch_event.live? ? "live" : "virtual"
  }
  before_create -> {
    self.official ||= official?
  }

  enum round: %w{
    quarterfinals
    semifinals
    finals
  }

  belongs_to :team_submission, counter_cache: true
  counter_culture :team_submission,
                  column_name: proc { |model|
                    "#{model.round}_submission_scores_count"
                  },
                  column_names: {
                    ["submission_scores.round = ?", rounds[:quarterfinals]] => 'quarterfinals_submission_scores_count',
                    ["submission_scores.round = ?", rounds[:semifinals]] => 'semifinals_submission_scores_count'
                  }
  counter_culture :team_submission,
                  column_name: proc { |model|
                    model.official? ? "#{model.round}_official_submission_scores_count" : nil
                  },
                  column_names: {
                    ["submission_scores.round = ? and submission_scores.official = ?", rounds[:quarterfinals], true] =>
                      'quarterfinals_official_submission_scores_count',
                    ["submission_scores.round = ? and submission_scores.official = ?", rounds[:semifinals], true] =>
                      'semifinals_official_submission_scores_count'
                  }
  belongs_to :judge_profile

  scope :complete, -> { where("completed_at IS NOT NULL") }
  scope :incomplete, -> { where("completed_at IS NULL") }

  scope :live, -> { where(event_type: :live) }
  scope :virtual, -> { where(event_type: :virtual) }

  scope :current, -> {
    joins(team_submission: { team: { season_registrations: :season } })
    .where("seasons.year = ?", Season.current.year)
  }

  scope :current_round, -> {
    case ENV.fetch("JUDGING_ROUND") { "QF" }
    when "QF"
      current.quarterfinals
    when "SF"
      current.semifinals
    else
      none
    end
  }

  scope :for_ambassador, ->(ambassador) {
    if ambassador.country == "US"
      joins(team_submission: :team)
      .where(
        "teams.state_province = ? AND teams.country = 'US'",
        ambassador.state_province
      )
    else
      where("teams.country = ?", ambassador.country)
    end
  }

  validates :team_submission_id, presence: true
  validates :judge_profile_id, presence: true

  validates_uniqueness_of :team_submission_id,
    scope: :judge_profile_id,
    conditions: -> { where(deleted_at: nil) }

  validates_uniqueness_of :judge_profile_id,
    scope: :team_submission_id,
    conditions: -> { where(deleted_at: nil) }

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

  def event_name
    judge_profile.selected_regional_pitch_event_name
  end

  def event_official_status
    if judge_profile.selected_regional_pitch_event.live?
      judge_profile.selected_regional_pitch_event.unofficial? ? "unofficial" : "official"
    else
      "virtual"
    end
  end

  def average_completed_live_score
    if event_type == "live" and event_official_status == "official"
      team_submission.quarterfinals_average_score
    else
      team_submission.average_unofficial_score
    end
  end

  def average_completed_virtual_score
    if event_type == "virtual"
      team_submission.quarterfinals_average_score
    elsif event_type == "live" and event_official_status == "unofficial"
      team_submission.quarterfinals_average_score
    else
      team_submission.average_unofficial_score
    end
  end

  def complete?
    completed_at != nil
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
    if team_submission.technical_checklist.present?
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

  def total_verified
    total_coding_verified +
      total_db_verified +
        total_mobile_verified +
          total_process_verified
  end

  def total_coding_verified
    if team_submission.technical_checklist.present?
      calculate_total_verified(
        team_submission.technical_checklist.technical_components,
        points_each: 1,
        points_max:  4
      )
    else
      0
    end
  end

  def total_db_verified
    if team_submission.technical_checklist.present?
      calculate_total_verified(
        team_submission.technical_checklist.database_components,
        points_each: 1,
        points_max: 1
      )
    else
      0
    end
  end

  def total_mobile_verified
    if team_submission.technical_checklist.present?
      calculate_total_verified(
        team_submission.technical_checklist.mobile_components,
        points_each: 2,
        points_max: 2
      )
    else
      0
    end
  end

  def total_process_verified
    if team_submission.technical_checklist.present?
      if team_submission.technical_checklist.pics_of_process.all? { |a|
          team_submission.technical_checklist.send(a).present?
        } and team_submission.screenshots.count >= 2
        3
      else
        0
      end
    else
      0
    end
  end

  def official?
    not (quarterfinals? and
         (team.selected_regional_pitch_event == judge_profile.selected_regional_pitch_event and
          team.selected_regional_pitch_event.live? and
          team.selected_regional_pitch_event.unofficial?))
  end

  private
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
