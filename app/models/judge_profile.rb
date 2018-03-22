class JudgeProfile < ActiveRecord::Base
  attr_accessor :used_global_invitation

  include Regioned
  regioned_source Account

  enum industry: %i(
    Science
    Technology
    Engineering
    Math
    Business
    Marketing
    Entrepreneurship
    Other
  )

  acts_as_paranoid

  scope :onboarded, -> {
    joins(account: :consent_waiver)
      .where("accounts.location_confirmed = ?", true)
      .where("accounts.email_confirmed_at IS NOT NULL")
  }

  scope :current, -> {
    joins(:current_account)
  }

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

  belongs_to :current_account, -> { current },
    foreign_key: :account_id,
    class_name: "Account",
    required: false

  belongs_to :user_invitation,
    required: false

  has_many :submission_scores, -> { current }, dependent: :destroy

  has_and_belongs_to_many :regional_pitch_events, -> { current.distinct }
  has_and_belongs_to_many :events, -> { current.distinct },
    class_name: "RegionalPitchEvent"

  has_many :judge_assignments, as: :assigned_judge, dependent: :destroy
  has_many :assigned_teams,
    through: :judge_assignments,
    source: :team

  validates :company_name, :job_title,
    presence: true

  delegate :first_name,
    to: :account,
    prefix: false

  def method_missing(method_name, *args, &block)
    begin
      account.public_send(method_name, *args, &block)
    rescue
      raise NoMethodError,
        "undefined method `#{method_name}' not found for #{self}"
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
    when "past_season"; "must log in"
    when "registered";  "must complete onboarding"
    when "ready";       "ready!"
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
    when "past_season"; "Log in now"
    when "registered";  "Complete your judge profile"
    when "ready";       "Log in for more details"
    else; "status missing (bug)"
    end
  end

  def complete_training!
    update_column(:completed_training_at, Time.current)
  end

  def training_completed?
    !!completed_training_at
  end

  def used_global_invitation?
    !!used_global_invitation
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
    selected_regional_pitch_event.live?
  end

  def event
    selected_regional_pitch_event
  end

  def assigned_team_names
    assigned_teams.pluck(:name)
  end

  def selected_regional_pitch_event
    regional_pitch_events.last or VirtualRegionalPitchEvent.new
  end

  def selected_regional_pitch_event_name
    selected_regional_pitch_event.name
  end

  def authenticated?
    true
  end

  def onboarded?
    account.email_confirmed? and
      consent_signed? and
        location_confirmed? and
          training_completed? and
              survey_completed?
  end

  def onboarding?
    not onboarded?
  end

  def scope_name
    "judge"
  end
end
