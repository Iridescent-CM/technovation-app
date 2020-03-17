class SubmissionScore < ActiveRecord::Base
  include Seasoned

  acts_as_paranoid

  include Regioned
  regioned_source Team, through: :team_submission

  SENIOR_LOW_SCORE_THRESHOLD = 19
  JUNIOR_LOW_SCORE_THRESHOLD = 14

  after_commit :update_team_score_summaries

  after_commit -> {
    update_columns(
      completed_too_fast: detect_if_completed_too_fast,
      completed_too_fast_repeat_offense: detect_if_too_fast_repeat_offense,
      seems_too_low: detect_if_raw_total_seems_too_low,
      approved_at: can_automatically_approve? ? Time.current : nil,
    )
  }, on: [:create, :update], if: :complete?

  after_commit -> {
    update_column(:official, official?)
  }, on: [:create, :update]

  before_create -> {
    self.seasons = [Season.current.year]
    self.event_type ||= LiveEventJudgingEnabled.(judge_profile) ?
      "live" : "virtual"
  }

  enum round: %w{
    quarterfinals
    semifinals
    finals
    off
  }

  belongs_to :team_submission, counter_cache: true

  counter_culture :team_submission,
    column_name: ->(score) {
      if score.complete?
        "complete_#{score.round}_submission_scores_count"
      else
        "pending_#{score.round}_submission_scores_count"
      end
    },

    column_names: {
      [
        "submission_scores.round = ? and submission_scores.completed_at IS NOT NULL",
        rounds[:quarterfinals]
      ] => 'complete_quarterfinals_submission_scores_count',

      [
        "submission_scores.round = ? and submission_scores.completed_at IS NULL",
        rounds[:quarterfinals]
      ] => 'pending_quarterfinals_submission_scores_count',

      [
        "submission_scores.round = ? and submission_scores.completed_at IS NOT NULL",
        rounds[:semifinals]
      ] => 'complete_semifinals_submission_scores_count',

      [
        "submission_scores.round = ? and submission_scores.completed_at IS NULL",
        rounds[:semifinals]
      ] => 'pending_semifinals_submission_scores_count'
    }

  counter_culture :team_submission,
    column_name: ->(score) {
      if score.official? and score.complete?
        "complete_#{score.round}_official_submission_scores_count"
      elsif score.official?
        "pending_#{score.round}_official_submission_scores_count"
      end
    },

    column_names: {
      [
        "submission_scores.round = ? and submission_scores.official = ? and submission_scores.completed_at IS NOT NULL",
        rounds[:quarterfinals],
        true
      ] => 'complete_quarterfinals_official_submission_scores_count',

      [
        "submission_scores.round = ? and submission_scores.official = ? and submission_scores.completed_at IS NULL",
        rounds[:quarterfinals],
        true
      ] => 'pending_quarterfinals_official_submission_scores_count',

      [
        "submission_scores.round = ? and submission_scores.official = ? and submission_scores.completed_at IS NOT NULL",
        rounds[:semifinals],
        true
      ] => 'complete_semifinals_official_submission_scores_count',

      [
        "submission_scores.round = ? and submission_scores.official = ? and submission_scores.completed_at IS NULL",
        rounds[:semifinals],
        true
      ] => 'pending_semifinals_official_submission_scores_count'
    }

  belongs_to :judge_profile

  counter_culture :judge_profile, column_name: ->(score) {
    if score.current_season? && score.complete? && score.quarterfinals?
      "quarterfinals_scores_count"
    end
  },
  column_names: {
    [
      "? = ANY (submission_scores.seasons) AND " +
      "submission_scores.completed_at IS NOT NULL AND " +
      "submission_scores.round = ?",
      Season.current.year.to_s,
      rounds[:quarterfinals],
    ] => 'quarterfinals_scores_count'
  }

  counter_culture :judge_profile, column_name: ->(score) {
    if score.current_season? && score.complete? && score.semifinals?
      "semifinals_scores_count"
    end
  },
  column_names: {
    [
      "? = ANY (submission_scores.seasons) AND " +
      "submission_scores.completed_at IS NOT NULL AND " +
      "submission_scores.round = ?",
      Season.current.year.to_s,
      rounds[:semifinals],
    ] => 'semifinals_scores_count'
  }

  scope :complete, -> { where("submission_scores.completed_at IS NOT NULL") }
  scope :incomplete, -> { where("submission_scores.completed_at IS NULL") }

  scope :complete_with_dropped, -> {
    with_deleted.where(
      "submission_scores.completed_at IS NOT NULL " +
      "AND (submission_scores.deleted_at IS NULL OR submission_scores.dropped_at IS NOT NULL)"
    )
  }

  scope :completed_too_fast, -> { where(completed_too_fast: true) }
  scope :completed_too_fast_repeat_offense, -> {
    where(completed_too_fast_repeat_offense: true)
  }

  scope :seems_too_low, -> { where(seems_too_low: true) }

  scope :approved, -> { where("submission_scores.approved_at IS NOT NULL") }
  scope :unapproved, -> { where(approved_at: nil) }

  scope :live, -> { where(event_type: :live) }
  scope :virtual, -> { where(event_type: :virtual) }

  scope :official, -> { where(official: true) }
  scope :unofficial, -> { where(official: false) }

  scope :current_round, -> {
    case SeasonToggles.judging_round
    when "qf"
      current.quarterfinals
    when "sf"
      current.semifinals
    else
      none
    end
  }

  validates :team_submission_id, presence: true
  validates :judge_profile_id, presence: true

  validates_uniqueness_of :team_submission_id,
    scope: [:judge_profile_id, :deleted_at]

  validates_uniqueness_of :judge_profile_id,
    scope: [:team_submission_id, :deleted_at]

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
           :team_division_name,
    to: :team_submission,
    prefix: false,
    allow_nil: false

  def self.from_csv(attrs, *args)
    create!(attrs, *args)
  end

  def self.judging_round(name)
    rounds[name]
  end

  def self.average_score(round)
    if first
      if round === :unofficial
        method_for_average = "average_unofficial_score"
      else
        method_for_average = "#{round}_average_score"
      end

      first.team_submission.public_send(method_for_average)
    else
      0.0
    end
  end

  def self.total_possible
    first && first.total_possible || 0.0
  end

  def self.total_possible_for(division)
    case division
    when "junior"
      60
    when "senior"
      80
    else
      0
    end
  end

  def overall_impression_comment
    overall_comment
  end

  def name
    [team_submission_app_name,
     team_submission_team_name].join(' by ')
  end

  def event_name
    team.selected_regional_pitch_event_name
  end

  def judge_name
    judge_profile.name
  end

  def team_name
    team.name
  end

  def event_official_status
    if team.selected_regional_pitch_event.live?
      team.selected_regional_pitch_event.unofficial? ? "unofficial" : "official"
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
    !!completed_at
  end

  def incomplete?
    not complete?
  end

  def complete!
    update(completed_at: Time.current)
  end

  def drop_score!
    update(dropped_at: Time.current)
    self.destroy
  end

  def approved?
    !!approved_at
  end

  def senior_team_division?
    team_submission.team.division.senior?
  end

  def junior_team_division?
    team_submission.team.division.junior?
  end

  def total
    ideation_total +
      technical_total +
        entrepreneurship_total +
          pitch_total +
            overall_impression_total
  end

  def total_for_question(question)
    public_send(question.field)
  end

  def total_for_section(section_name)
    public_send("#{section_name}_total")
  end

  def comment_for_section(section_name)
    public_send("#{section_name}_comment")
  end

  def raw_total
    total
  end

  def ideation_total
    ideation_1 +
      ideation_2 +
        ideation_3 +
          ideation_4
  end

  def technical_total
    technical_1 +
      technical_2 +
        technical_3 +
          technical_4
  end

  def entrepreneurship_total
    return 0 if junior_team_division?

    entrepreneurship_1 +
      entrepreneurship_2 +
        entrepreneurship_3 +
          entrepreneurship_4
  end

  def pitch_total
    pitch_1 +
      pitch_2
  end

  def overall_impression_total
    overall_1 +
      overall_2
  end

  def overall_total
    overall_impression_total
  end


  def total_possible
    self.class.total_possible_for(team_submission.team_division_name)
  end

  def status
    if !!completed_at
      'complete'
    else
      'pending'
    end
  end

  def official?
    !(quarterfinals? &&
      judge_profile.events.include?(team.event) &&
        team.event.live? &&
          team.event.unofficial?)
  end

  def approve!
    update_column(:approved_at, Time.current)
  end

  def detect_if_completed_too_fast
    completed_at - created_at < 10.minutes
  end

  def detect_if_too_fast_repeat_offense
    detect_if_completed_too_fast &&
      self.class
        .current_round
        .completed_too_fast
        .where.not(id: id)
        .exists?(judge_profile: judge_profile)
  end

  def detect_if_raw_total_seems_too_low
    (senior_team_division? && raw_total < SENIOR_LOW_SCORE_THRESHOLD) ||
      (junior_team_division? && raw_total < JUNIOR_LOW_SCORE_THRESHOLD)
  end

  def can_automatically_approve?
    !detect_if_too_fast_repeat_offense && !detect_if_raw_total_seems_too_low
  end

  def pending_approval?
    complete? && !approved?
  end

  private

  def update_team_score_summaries
    team_submission.update_score_summaries
  end
end
