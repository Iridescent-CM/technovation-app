class SubmissionScore < ActiveRecord::Base
  include Seasoned

  acts_as_paranoid

  include Regioned
  regioned_source Team, through: :team_submission

  SENIOR_LOW_SCORE_THRESHOLD = 25
  JUNIOR_LOW_SCORE_THRESHOLD = 20
  BEGINNER_LOW_SCORE_THRESHOLD = 15

  before_commit -> {
    self.judge_recusal_comment = "" if judge_recusal_reason != "other"
  }

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

  after_restore -> {
    update_column(:dropped_at, nil)
  }

  enum round: %w{
    quarterfinals
    semifinals
    finals
    off
  }

  enum judge_recusal_reason: {
    submission_not_in_english: "submission_not_in_english",
    knows_team: "knows_team",
    other: "other"
  }

  belongs_to :team_submission, counter_cache: true

  counter_culture :team_submission,
    column_name: ->(score) {
      if score.complete?
        "complete_#{score.round}_submission_scores_count"
      elsif score.incomplete? && !score.judge_recusal?
        "pending_#{score.round}_submission_scores_count"
      elsif score.judge_recusal?
        "judge_recusal_count"
      end
    },

    column_names: {
      [
        "submission_scores.round = ? and submission_scores.completed_at IS NOT NULL",
        rounds[:quarterfinals]
      ] => 'complete_quarterfinals_submission_scores_count',

      [
        "submission_scores.round = ? and submission_scores.completed_at IS NULL and submission_scores.judge_recusal = FALSE",
        rounds[:quarterfinals]
      ] => 'pending_quarterfinals_submission_scores_count',

      [
        "submission_scores.round = ? and submission_scores.completed_at IS NOT NULL",
        rounds[:semifinals]
      ] => 'complete_semifinals_submission_scores_count',

      [
        "submission_scores.round = ? and submission_scores.completed_at IS NULL and submission_scores.judge_recusal = FALSE",
        rounds[:semifinals]
      ] => 'pending_semifinals_submission_scores_count'
    }

  counter_culture :team_submission,
    column_name: ->(score) {
      if score.official? && score.complete?
        "complete_#{score.round}_official_submission_scores_count"
      elsif score.official? && score.incomplete? && !score.judge_recusal?
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
        "submission_scores.round = ? and submission_scores.official = ? and submission_scores.completed_at IS NULL and submission_scores.judge_recusal = FALSE",
        rounds[:quarterfinals],
        true
      ] => 'pending_quarterfinals_official_submission_scores_count',

      [
        "submission_scores.round = ? and submission_scores.official = ? and submission_scores.completed_at IS NOT NULL",
        rounds[:semifinals],
        true
      ] => 'complete_semifinals_official_submission_scores_count',

      [
        "submission_scores.round = ? and submission_scores.official = ? and submission_scores.completed_at IS NULL and submission_scores.judge_recusal = FALSE",
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

  counter_culture :judge_profile, column_name: ->(score) {
    if score.current_season? && score.incomplete? && score.judge_recusal?
      "recusal_scores_count"
    end
  }

  scope :complete, -> { where("submission_scores.completed_at IS NOT NULL") }
  scope :incomplete, -> { where("submission_scores.completed_at IS NULL AND submission_scores.judge_recusal = FALSE") }
  scope :complete_and_incomplete_without_recused, -> { where("submission_scores.judge_recusal = FALSE") }

  scope :complete_with_dropped, -> {
    with_deleted.where(
      "submission_scores.completed_at IS NOT NULL " +
      "AND (submission_scores.deleted_at IS NULL OR submission_scores.dropped_at IS NOT NULL)"
    )
  }

  scope :dropped, -> {
    with_deleted.where("submission_scores.dropped_at IS NOT NULL")
  }

  scope :completed_too_fast, -> { where(completed_too_fast: true) }
  scope :completed_too_fast_repeat_offense, -> {
    where(completed_too_fast_repeat_offense: true)
  }

  scope :seems_too_low, -> { where(seems_too_low: true) }

  scope :approved, -> { where("submission_scores.approved_at IS NOT NULL") }
  scope :unapproved, -> { where(approved_at: nil) }

  scope :recused, -> { where(judge_recusal: true) }
  scope :not_recused, -> { where(judge_recusal: false) }

  scope :live, -> { where(event_type: :live) }
  scope :virtual, -> { where(event_type: :virtual) }

  scope :official, -> { where(official: true) }
  scope :unofficial, -> { where(official: false) }

  scope :not_started, -> { where("created_at = updated_at AND completed_at IS NULL") }
  scope :in_progress, -> { where("created_at != updated_at AND completed_at IS NULL") }

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

  scope :judge_not_deleted, -> {
    includes(:judge_profile)
      .references(:judge_profiles)
      .where("judge_profiles.id IS NOT NULL AND judge_profiles.deleted_at IS NULL")
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
           :submission_type,
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

  def self.total_possible_score_for(division:, season: Season.current.year)
    JudgeQuestions
      .new(division: division, season: season)
      .call
      .uniq(&:field)
      .sum(&:worth)
  end

  def self.total_possible_points_for_section(division:, section:, season: Season.current.year)
    JudgeQuestions
      .new(division: division, season: season)
      .call
      .select { |question| question.section == section }
      .uniq { |question| question.idx }
      .sum(&:worth)
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

  def event_type_display_name
    event_type == "live" ? "Pitch Event" : "Online"
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

  def dropped?
    !!dropped_at
  end

  def suspicious?
    completed_too_fast ||
    seems_too_low ||
    completed_too_fast_repeat_offense
  end

  def suspicious_reasons
    flags = []
    flags << "Completed too fast" if completed_too_fast?
    flags << "Seems too low" if seems_too_low?
    flags << "Completed too fast (repeat offense)" if completed_too_fast_repeat_offense?
    flags
  end

  def updated?
    created_at != updated_at
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

  def beginner_team_division?
    team_submission.team.division.beginner?
  end

  def total(season = Season.current.year)
    JudgeQuestions
      .new(division: team_division_name, season: season)
      .call
      .uniq(&:field)
      .sum { |question| instance_eval(question.field.to_s) }
  end

  def total_for_question(question)
    public_send(question.field)
  end

  def total_for_section(section_name)
    public_send("#{section_name}_total")
  end

  def total_points_for_section(division, section_name)
    self.class.total_possible_points_for_section(division: division, section: section_name)
  end

  def comment_for_section(section_name)
    public_send("#{section_name}_comment")
  end

  def raw_total
    total
  end

  def project_details_total
    project_details_1
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
    return 0 if beginner_team_division?

    entrepreneurship_1 +
      entrepreneurship_2 +
        entrepreneurship_3 +
          entrepreneurship_4
  end

  def pitch_total
    pitch_1 +
      pitch_2 +
        pitch_3 +
          pitch_4 +
            pitch_5 +
              pitch_6 +
                pitch_7 +
                  pitch_8
  end

  def demo_total
    demo_1 +
      demo_2 +
        demo_3
  end

  def overall_impression_total
    overall_1 +
      overall_2
  end

  def overall_total
    overall_impression_total
  end

  def total_possible
    self.class.total_possible_score_for(division: team_submission.team_division_name)
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
      (junior_team_division? && raw_total < JUNIOR_LOW_SCORE_THRESHOLD) ||
      (beginner_team_division? && raw_total < BEGINNER_LOW_SCORE_THRESHOLD)
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
