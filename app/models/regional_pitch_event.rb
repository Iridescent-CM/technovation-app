class RegionalPitchEvent < ActiveRecord::Base
  include Seasoned

  after_validation -> {
    AddTeamToRegionalEvent::RemoveIncompatibleDivisionTeams.(self)
  }

  after_update -> {
    if saved_change_to_unofficial?
      team_submissions.find_each(&:update_average_scores)
    end
  }

  after_create -> {
    RegisterToCurrentSeasonJob.perform_later(self);
  }

  scope :unofficial, -> { where(unofficial: true) }
  scope :official, -> { where(unofficial: false) }

  belongs_to :regional_ambassador_profile

  has_and_belongs_to_many :divisions

  has_and_belongs_to_many :judges,
    -> { includes(:account).references(:accounts).distinct },
    class_name: "JudgeProfile"

  has_and_belongs_to_many :teams, -> { distinct.joins(:team_submissions) }
  has_many :team_submissions, through: :teams

  has_many :messages, as: :regarding
  has_many :multi_messages, as: :regarding

  validates :name,
            :starts_at,
            :ends_at,
            :division_ids,
            :city,
            :venue_address,
    presence: true

  delegate :state_province,
           :country,
           :timezone,
    to: :regional_ambassador_profile,
    prefix: false

  scope :available_to, ->(record) {
    if record.present?
      case record
      when JudgeProfile
        if record.country === "US"
          joins(regional_ambassador_profile: :account)
          .where("accounts.country = 'US' AND accounts.state_province = ?",
                 record.state_province)
        else
          joins(regional_ambassador_profile: :account)
          .where("accounts.country = ?", record.country)
        end
      when TeamSubmission
        if record.country === "US"
          joins(:divisions)
          .where("divisions.id = ?", record.division_id)
          .joins(regional_ambassador_profile: :account)
          .where(
            "accounts.country = 'US' AND accounts.state_province = ?",
            record.state_province
          )
        else
          joins(:divisions)
          .where("divisions.id = ?", record.division_id)
          .joins(regional_ambassador_profile: :account)
          .where("accounts.country = ?", record.country)
        end
      end
    else
      none
    end
  }

  scope :in_region_of, ->(ambassador) {
    if ambassador.country == "US"
      joins(regional_ambassador_profile: :account)
      .where("accounts.country = 'US' AND accounts.state_province = ?", ambassador.state_province)
    else
      joins(regional_ambassador_profile: :account)
      .where("accounts.country = ?", ambassador.country)
    end
  }

  def self.find(id)
    if id == "virtual"
      VirtualRegionalPitchEvent.new
    else
      super
    end
  end

  def to_list_json
    {
      id: id,
      name: name,
      city: city,
      venue_address: venue_address,
      division_names: division_names,
      division_ids: division_ids,
      day: day,
      date: date,
      time: time,
      tz: timezone,
      starts_at: starts_at,
      ends_at: ends_at,
      eventbrite_link: eventbrite_link,
      errors: {},
    }
  end

  def to_create_json
    {
      id: id,
      day: day,
      date: date,
      time: time,
      tz: timezone,
    }
  end

  def to_update_json
    {
      id: id,
      day: day,
      date: date,
      time: time,
      tz: timezone,
    }
  end

  def friendly_name
    "#{name} in #{city} on #{date_time}"
  end

  def division_names
    divisions.flat_map(&:name).join(", ")
  end

  def date_time
    [starts_at.in_time_zone(timezone).strftime("%a %b %e, %-I:%M%P"),
     "-",
     ends_at.in_time_zone(timezone).strftime("%-I:%M%P"),
     "TZ:",
     regional_ambassador_profile.timezone].join(' ')
  end

  def day
    starts_at.in_time_zone(timezone).strftime("%A")
  end

  def date
    starts_at.in_time_zone(timezone).strftime("%B %e")
  end

  def time
    [starts_at.in_time_zone(timezone).strftime("%-I:%M%P"),
     "-",
     ends_at.in_time_zone(timezone).strftime("%-I:%M%P")].join(" ")
  end

  def live?
    true
  end

  def virtual?
    false
  end

  def name_with_friendly_country_prefix
    "#{FriendlyCountry.(regional_ambassador_profile.account)} - #{name}"
  end
end
