class RegionalPitchEvent < ActiveRecord::Base
  scope :unofficial, -> { where(unofficial: true) }
  scope :official, -> { where(unofficial: false) }

  belongs_to :regional_ambassador_profile

  has_and_belongs_to_many :divisions
  has_and_belongs_to_many :teams, -> { uniq }

  validates :name, :starts_at, :ends_at, :division_ids, :city, :venue_address,
    presence: true

  delegate :state_province, :country, :timezone,
    to: :regional_ambassador_profile,
    prefix: false

  scope :available_to, ->(submission) {
    if submission.country === "US"
      joins(:divisions)
      .where("divisions.id = ?", submission.division_id)
      .joins(regional_ambassador_profile: :account)
      .where(
        "accounts.country = 'US' AND accounts.state_province = ?",
        submission.state_province
      )
    else
      joins(:divisions)
      .where("divisions.id = ?", submission.division_id)
      .joins(regional_ambassador_profile: :account)
      .where("accounts.country = ?", submission.country)
    end
  }

  def friendly_name
    "#{name} in #{city} on #{date_time}"
  end

  def division_names
    divisions.flat_map(&:name).to_sentence
  end

  def date_time
    [starts_at.in_time_zone(timezone).strftime("%a %b %e, %H:%M"),
     "-",
     ends_at.in_time_zone(timezone).strftime("%H:%M"),
     regional_ambassador_profile.timezone].join(' ')
  end

  def live?
    true
  end
end
