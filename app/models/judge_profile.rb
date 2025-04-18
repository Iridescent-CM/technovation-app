class JudgeProfile < ActiveRecord::Base
  include Regioned
  regioned_source Account

  enum industry: %i[
    Science
    Technology
    Engineering
    Math
    Business
    Marketing
    Entrepreneurship
    Other
  ]

  acts_as_paranoid

  scope :onboarded, -> { where(onboarded: true) }
  scope :onboarding, -> { where(onboarded: false) }

  scope :suspended, -> { where(suspended: true) }

  scope :current, -> { joins(:current_account) }

  scope :not_attending_live_event, -> {
    includes(:regional_pitch_events)
      .references(:regional_pitch_events)
      .where("regional_pitch_events.id IS NULL")
  }

  belongs_to :account, required: false
  accepts_nested_attributes_for :account
  validates_associated :account, if: -> { user_invitation.blank? }

  before_validation -> {
    if account.blank? and user_invitation.blank?
      errors.add(:account, "is required unless there's a user invitation")
      errors.add(
        :user_invitation,
        "is required unless there's an account"
      )
    end
  }

  attr_accessor :destroyed
  after_destroy -> { self.destroyed = true }

  after_commit -> {
    return if destroyed

    if can_be_marked_onboarded?
      update_column(:onboarded, true)
    else
      update_column(:onboarded, false)
    end
  }

  belongs_to :current_account, -> { current },
    foreign_key: :account_id,
    class_name: "Account",
    required: false

  belongs_to :user_invitation,
    required: false

  has_many :judge_profile_judge_types,
    dependent: :destroy

  has_many :judge_types,
    through: :judge_profile_judge_types

  has_and_belongs_to_many :regional_pitch_events, -> { current }
  has_and_belongs_to_many :events, -> { current },
    class_name: "RegionalPitchEvent",
    after_add: :update_judge_info_in_crm,
    after_remove: :update_judge_info_in_crm

  has_many :judge_assignments,
    -> { current },
    as: :assigned_judge,
    dependent: :destroy

  has_many :assigned_teams,
    through: :judge_assignments,
    source: :team

  has_many :submission_scores, -> { current }, dependent: :destroy
  has_many :scores, -> { current }, class_name: "SubmissionScore"

  has_many :current_complete_scores, -> { current.complete },
    class_name: "SubmissionScore"

  has_many :completed_scores, -> { complete_with_dropped },
    class_name: "SubmissionScore"

  has_many :current_completed_scores, -> { current.complete_with_dropped },
    class_name: "SubmissionScore"

  has_many :current_quarterfinals_complete_scores,
    -> { current.complete.quarterfinals },
    class_name: "SubmissionScore"

  validates :company_name, :job_title,
    presence: true

  delegate :first_name,
    to: :account,
    prefix: false

  def method_missing(method_name, ...)
    account.public_send(method_name, ...)
  end

  def is_team?
    false
  end

  def industry_text
    if industry == "Other"
      industry_other
    else
      industry
    end
  end

  def status
    if current_account && onboarded?
      "ready"
    elsif current_account
      "registered"
    else
      "past_season"
    end
  end

  def human_status
    case status
    when "past_season" then "must log in"
    when "registered" then "must complete onboarding"
    when "ready" then "ready!"
    else; "status missing (bug)"
    end
  end

  def status_explained
    case status
    when "ready"
      "This judge is ready for your event!"
    when "registered"
      "This judge has some required steps before they can judge your event"
    when "past_season"
      "This judge is from a past season and hasn't logged in yet"
    else
      "Status is missing, this is a bug"
    end
  end

  def friendly_status
    case status
    when "past_season" then "Log in now"
    when "registered" then "Complete your judge profile"
    when "ready" then "Log in for more details"
    else; "status missing (bug)"
    end
  end

  def suspend!
    update!(suspended: true)
  end

  def unsuspend!
    update!(suspended: false)
  end

  def complete_training!
    update(completed_training_at: Time.current)
  end

  def training_completed?
    !!completed_training_at
  end

  def training_completed_without_save!
    self.completed_training_at = Time.current
  end

  def survey_completed_without_save!
    self.survey_completed = true
  end

  def has_incomplete_scores?
    submission_scores.current_round.incomplete.any?
  end

  def has_no_incomplete_scores?
    submission_scores.current_round.incomplete.empty?
  end

  def last_incomplete_score
    submission_scores.current_round.incomplete.last
  end

  def live_event?
    regional_pitch_events.any? { |e| e.live? }
  end

  def assigned_team_names
    assigned_teams.pluck(:name)
  end

  def assigned_teams_for_event(event)
    assigned_teams.where(id: event.teams.pluck(:id))
  end

  def authenticated?
    true
  end

  def onboarding?
    !onboarded?
  end

  def scope_name
    "judge"
  end

  def rebranded?
    true
  end

  def can_be_marked_onboarded?
    account &&
      account.email_confirmed? &&
      consent_signed? &&
      training_completed?
  end

  private

  def update_judge_info_in_crm(_event)
    CRM::UpsertProgramInfoJob.perform_later(
      account_id: account.id,
      profile_type: "judge"
    )
  end
end
