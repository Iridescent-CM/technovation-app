class RegionalPitchEvent < ActiveRecord::Base
  include Seasoned

  include Regioned
  regioned_source Account, through: :ambassador

  after_validation -> {
    AddTeamToRegionalEvent::RemoveIncompatibleDivisionTeams.(self)
  }

  after_update -> {
    if saved_change_to_unofficial?
      team_submissions.flat_map(&:scores).each(&:save)
      team_submissions.find_each(&:update_score_summaries)
    end
  }

  after_create -> {
    RegisterToCurrentSeasonJob.perform_later(self);
  }

  scope :unofficial, -> { where(unofficial: true) }
  scope :official, -> { where(unofficial: false) }

  scope :by_division, ->(division) {
    joins(:divisions)
      .where("divisions.name = ?", Division.names[division])
  }

  belongs_to :ambassador,
    class_name: "ChapterAmbassadorProfile",
    foreign_key: :chapter_ambassador_profile_id

  has_and_belongs_to_many :divisions

  has_and_belongs_to_many :judges,
    -> { includes(:account).references(:accounts) },
    join_table: :judge_profiles_regional_pitch_events,
    class_name: "JudgeProfile"

  has_many :judge_assignments,
    ->(evt) { where(team: evt.teams) },
    through: :judges

  has_and_belongs_to_many :user_invitations,
    -> { includes(:account).references(:accounts) },
    class_name: "UserInvitation"

  has_and_belongs_to_many :teams,
    -> { joins(:team_submissions) },
    after_add: :update_teams_count,
    after_remove: :update_teams_count

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
    to: :ambassador,
    prefix: false

  delegate :name,
    to: :ambassador,
    prefix: true

  scope :visible_to, ->(admin_chapter_ambassador) {
    if admin_chapter_ambassador.admin?
      unscoped
    elsif admin_chapter_ambassador.country_code == "US"
      joins(ambassador: :account)
        .where(
          "accounts.country = 'US' AND accounts.state_province = ?",
          admin_chapter_ambassador.state_province
        )
    else
      joins(ambassador: :account)
        .where(
          "accounts.country = ?",
          admin_chapter_ambassador.country_code
        )
    end
  }

  scope :available_to, ->(record) {
    "#{record.class.name}EventScope".constantize.new(self, record).execute
  }

  def self.find(id)
    if id == "virtual"
      VirtualRegionalPitchEvent.new
    else
      super
    end
  end

  def officiality
    if Time.zone.now >= ImportantDates.rpe_officiality_finalized
      official? ? :official : :unofficial
    else
      :pending
    end
  end

  def official?
    not unofficial?
  end

  def judge_list
    judges + user_invitations
  end

  def accounts
    judges.map(&:account) + user_invitations
  end

  def attendees
    judge_list + teams
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
      event_link: event_link,
      capacity: capacity,
      officiality: officiality,
      errors: {},
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
     ambassador.timezone].join(' ')
  end

  def day
    starts_at.in_time_zone(timezone).strftime("%A")
  end

  def date
    starts_at.in_time_zone(timezone).strftime("%B %e")
  end

  def time
    [starts_at.in_time_zone(timezone).strftime("%-k:%M"),
     "-",
     ends_at.in_time_zone(timezone).strftime("%-k:%M")].join(" ")
  end

  def live?
    true
  end

  def virtual?
    false
  end

  def at_team_capacity?
    if (capacity.nil? || capacity.to_i == 0)
      false
    else
      teams.length.to_i >= capacity.to_i
    end
  end

  def name_with_friendly_country_prefix
    "#{FriendlyCountry.(ambassador.account)} - #{name}"
  end

  def update_teams_count(team = nil)
    update(teams_count: teams.count)
  end
end

class EventScope
  attr_reader :scope, :record

  def initialize(scope, record)
    @scope = scope
    @record = record
    freeze
  end
end

class JudgeProfileEventScope < EventScope
  def execute
    if record.country_code === "US"
      scope.current
        .joins(ambassador: :account)
        .where(
          "accounts.country = 'US' AND accounts.state_province = ?",
          record.state_province
        )
    else
      scope.current
        .joins(ambassador:  :account)
        .where("accounts.country = ?", record.country_code)
    end
  end
end

class TeamSubmissionEventScope < EventScope
  def execute
    if record.country === "US"
      scope.current
        .joins(:divisions)
        .where("divisions.id = ?", record.division_id)
        .joins(ambassador: :account)
        .where(
          "accounts.country = 'US' AND accounts.state_province = ?",
          record.state_province
        )
    else
      scope.current
        .joins(:divisions)
        .where("divisions.id = ?", record.division_id)
        .joins(ambassador: :account)
        .where("accounts.country = ?", record.country)
    end
  end
end

class NullTeamSubmissionEventScope < EventScope
  def execute
    scope.unscoped.none
  end
end
