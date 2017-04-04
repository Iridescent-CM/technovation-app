class JudgeProfile < ActiveRecord::Base
  include Elasticsearch::Model

  index_name "#{Rails.env}_profiles"
  document_type 'judge'
  settings index: { number_of_shards: 1, number_of_replicas: 1 } do
    mappings do
      indexes :region_division_names, index: "not_analyzed"
    end
  end

  after_destroy { IndexModelJob.perform_later("delete", "JudgeProfile", id) }

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

  def as_indexed_json(options = {})
    mp = account && account.mentor_profile
    {
      "id" => id,
      "mentor_profile_id" => mp && mp.id,
      "regional_pitch_event_id" => selected_regional_pitch_event.id,
      "region_division_names" => mp && mp.team_region_division_names
    }
  end
end
