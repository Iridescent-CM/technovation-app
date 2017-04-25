class RegionalPitchEvent < ActiveRecord::Base
  after_validation -> {
    teams.includes(:regional_pitch_events,
                   team_submissions: :submission_scores).find_each do |team|
      if not division_ids.include?(team.division.id)
        team.remove_from_live_event
      end
    end
  }

  scope :unofficial, -> { where(unofficial: true) }
  scope :official, -> { where(unofficial: false) }

  belongs_to :regional_ambassador_profile

  has_and_belongs_to_many :divisions

  has_and_belongs_to_many :teams, -> { distinct.joins(:team_submissions).select("teams.*, team_submissions.*, LOWER(teams.name)") }

  has_and_belongs_to_many :judges,
    -> { includes(:account).references(:accounts).distinct },
    class_name: "JudgeProfile"

  has_many :team_submissions, through: :teams

  has_many :messages, as: :regarding
  has_many :multi_messages, as: :regarding

  validates :name, :starts_at, :ends_at, :division_ids, :city, :venue_address,
    presence: true

  delegate :state_province, :country, :timezone,
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
      Team::VirtualRegionalPitchEvent.new
    else
      super
    end
  end

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
     "Timezone:",
     regional_ambassador_profile.timezone].join(' ')
  end

  def live?
    true
  end

  def virtual?
    false
  end
end
