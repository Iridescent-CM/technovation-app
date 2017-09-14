class JudgeProfile < ActiveRecord::Base
  scope :onboarded, -> {
    joins(account: :consent_waiver)
      .where("accounts.location_confirmed = ?", true)
      .where("accounts.email_confirmed_at IS NOT NULL")
  }

  scope :current, -> {
    joins(:current_account)
  }

  scope :for_ambassador, ->(ambassador) {
    if ambassador.country == "US"
      joins(:account)
      .where("accounts.country = 'US' AND accounts.state_province = ?",
             ambassador.state_province)
    else
      joins(:account)
      .where("accounts.country = ?", ambassador.country)
    end
  }

  scope :not_attending_live_event, -> {
    includes(:regional_pitch_events)
      .references(:regional_pitch_events)
      .where("regional_pitch_events.id IS NULL")
  }

  belongs_to :account
  accepts_nested_attributes_for :account
  validates_associated :account

  belongs_to :current_account, -> { current },
    required: false

  has_many :submission_scores

  has_and_belongs_to_many :regional_pitch_events, -> { distinct }
  has_many :judge_assignments
  has_many :assigned_teams, through: :judge_assignments, source: :team

  validates :company_name, :job_title,
    presence: true

  def method_missing(method_name, *args)
    begin
      account.public_send(method_name, *args)
    rescue
      raise NoMethodError, "undefined method `#{method_name}' not found for #{self}"
    end
  end

  def remove_from_live_event
    submission_scores.destroy_all
    judge_assignments.destroy_all
    regional_pitch_events.destroy_all
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
        location_confirmed?
  end

  def scope_name
    "judge"
  end
end
