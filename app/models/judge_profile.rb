class JudgeProfile < ActiveRecord::Base
  scope :full_access, -> {
    joins(account: :consent_waiver)
      .where("accounts.location_confirmed = ?", true)
  }

  scope :current, -> {
    joins(account: :seasons)
    .where("seasons.year = ?", Season.current.year)
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

  has_many :submission_scores

  has_and_belongs_to_many :regional_pitch_events, -> { uniq }

  validates :company_name, :job_title,
    presence: true

  def method_missing(method_name, *args)
    begin
      account.public_send(method_name, *args)
    rescue
      raise NoMethodError, "undefined method `#{method_name}' not found for #{self}"
    end
  end

  def selected_regional_pitch_event
    regional_pitch_events.last or Team::VirtualRegionalPitchEvent.new
  end

  def selected_regional_pitch_event_name
    selected_regional_pitch_event.name
  end

  def authenticated?
    true
  end

  def full_access_enabled?
    consent_signed? and location_confirmed?
  end

  def type_name
    "judge"
  end
end
