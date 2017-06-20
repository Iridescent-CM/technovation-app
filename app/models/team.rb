class Team < ActiveRecord::Base
  include Casting::Client
  delegate_missing_methods

  include Elasticsearch::Model

  index_name "#{ENV.fetch("ES_RAILS_ENV") { Rails.env }}_teams"
  document_type 'team'
  settings index: { number_of_shards: 1, number_of_replicas: 1 }

  geocoded_by :primary_location
  reverse_geocoded_by :latitude, :longitude do |team, results|
    team.update_address_details_from_reverse_geocoding(results)
  end

  after_destroy { IndexModelJob.perform_later("delete", "Team", id) }

  after_commit :register_to_season, on: :create

  after_save -> {
    submission.touch if submission.present?
  }, if: :saved_change_to_division_id?

  def as_indexed_json(options = {})
    as_json(
      only: %w{id name description spot_available?},
      methods: :spot_available?
    )
  end

  def type_name
    "student" # Needed for RPE selection views that are shared by judges
  end

  def photo
    team_photo
  end

  mount_uploader :team_photo, TeamPhotoProcessor

  scope :current, -> {
    joins(season_registrations: :season)
    .where("seasons.year = ?", Season.current.year)
  }

  Division.names.keys.each do |division_name|
    scope division_name, -> {
      joins(:division).where("divisions.name = ?", Division.names[division_name])
    }
  end

  scope :past, -> {
    eager_load(season_registrations: :season)
    .where.not(id: current.map(&:id).uniq)
  }

  scope :without_mentor, -> {
    where.not(id: Membership.where(member_type: "MentorProfile").map(&:joinable_id))
  }

  scope :for_ambassador, ->(ambassador) {
    if ambassador.country == "US"
      where("state_province = ? AND country = 'US'", ambassador.state_province)
    else
      where("country = ?", ambassador.country)
    end
  }

  scope :not_attending_live_event, -> {
    includes(:regional_pitch_events)
      .references(:regional_pitch_events)
      .where("regional_pitch_events.id IS NULL")
  }

  scope :accepting_mentor_requests, -> { where(accepting_mentor_requests: true) }

  scope :accepting_student_requests, -> { where(accepting_student_requests: true) }

  has_many :season_registrations, as: :registerable
  has_many :seasons, through: :season_registrations

  belongs_to :division

  has_many :team_submissions, dependent: :destroy
  has_many :submission_scores, through: :team_submissions

  has_many :memberships, as: :joinable, dependent: :destroy

  has_many :students, -> { order("memberships.created_at") },
    through: :memberships,
    source: :member,
    source_type: "StudentProfile"

  has_many :mentors, -> { order("memberships.created_at") },
    through: :memberships,
    source: :member,
    source_type: "MentorProfile"

  has_many :team_member_invites, dependent: :destroy
  has_many :mentor_invites, dependent: :destroy
  has_many :join_requests, as: :joinable, dependent: :destroy

  has_many :pending_student_invites, -> { pending.for_students }, class_name: "TeamMemberInvite"
  has_many :pending_mentor_invites, -> { pending }, class_name: "MentorInvite"
  has_many :pending_requests, -> { pending }, class_name: "JoinRequest", as: :joinable

  has_many :pending_student_join_requests, -> { pending.for_students },
    class_name: "JoinRequest",
    as: :joinable

  has_and_belongs_to_many :regional_pitch_events, -> { distinct },
    after_add: :update_submission,
    after_remove: :update_submission

  has_many :judge_assignments
  has_many :assigned_judges, through: :judge_assignments, source: :judge_profile

  validates :name, uniqueness: { case_sensitive: false }, presence: true
  validates :description, presence: true
  validates :division, presence: true
  validates :team_photo, verify_cached_file: true

  delegate :name, to: :division, prefix: true

  def remove_from_live_event
    team_submissions.flat_map(&:submission_scores).each(&:destroy)
    judge_assignments.destroy_all
    regional_pitch_events.destroy_all
  end

  def update_submission(team)
    submission.touch if submission.present?
  end

  def eligible_events
    if submission.present?
      [VirtualRegionalPitchEvent.new] + RegionalPitchEvent.available_to(submission)
    else
      []
    end
  end

  def ages
    students.map(&:age).compact.uniq
  end

  def selected_regional_pitch_event
    regional_pitch_events.last or VirtualRegionalPitchEvent.new
  end

  def selected_regional_pitch_event_name
    selected_regional_pitch_event.name
  end

  def region_name
    if %w{Brasil Brazil}.include?(state_province || "")
      "Brazil"
    elsif country == "US"
      state = Country["US"].states[state_province.strip]
      (state && state['name']) || state_province
    else
      FriendlyCountry.(self)
    end
  end

  def region_division_name
    Rails.cache.fetch("#{cache_key}/region_division_name") do
      name = country || ""
      if name == "US"
        name += "_#{state_province}"
      end
      name += ",#{division.name}"
    end
  end

  def junior?
    division.junior?
  end

  def senior?
    division.senior?
  end

  def current_team_submission
    team_submissions.current.first
  end

  def student_emails
    students.flat_map(&:email)
  end

  def mentor_emails
    mentors.flat_map(&:email)
  end

  def members
    students + mentors
  end

  def spot_available?
    (students + pending_student_invites + pending_student_join_requests).size < 5
  end

  def primary_location
    [city, state_province, Country[country].try(:name)].reject(&:blank?).join(', ')
  end

  def pending_invitee_emails
    team_member_invites.pending.flat_map(&:invitee_email)
  end

  def add_mentor(mentor)
    return if !!!mentor

    if invite = mentor.mentor_invites.pending.find_by(team_id: id)
      invite.accepted!
      return
    end

    if join_request = mentor.join_requests.pending.find_by(joinable: self)
      join_request.approved!
      return
    end

    if not mentors.include?(mentor)
      mentors << mentor
      save
    end
  end

  def add_student(student)
    return if !!!student

    if invite = student.team_member_invites.pending.find_by(team_id: id)
      invite.accepted!
      return
    end

    if join_request = student.join_requests.pending.find_by(joinable: self)
      join_request.approved!
      return
    end

    if not students.include?(student) and spot_available?
      students << student
      reconsider_division
      save
    elsif students.include?(student)
      errors.add(:add_student, "Student is already on this team")
    elsif not spot_available?
      errors.add(:add_student, "No spot available to add this student")
    end
  end

  def remove_mentor(mentor)
    membership = Membership.find_by(joinable: self,
                                    member_type: "MentorProfile",
                                    member_id: mentor.id)
    membership.destroy

    if invite = mentor.mentor_invites.find_by(team_id: id)
      invite.deleted!
    end

    if join_request = mentor.join_requests.find_by(joinable: self)
      join_request.deleted!
    end
  end

  def reconsider_division_with_save
    reconsider_division
    save
  end

  def reconsider_division
    self.division = Division.for(self)
  end

  def current?
    seasons.include?(Season.current)
  end

  def invited_mentor?(mentor)
    mentor_invites.pending.where(invitee_id: mentor.id, invitee_type: "MentorProfile").any?
  end

  def submission
    team_submissions.current.last or NullTeamSubmission.new
  end

  def unassigned?
    not assigned?
  end

  def assigned?
    judge_assignments.any?
  end

  def assigned_judge_names
    assigned_judges.flat_map(&:full_name)
  end

  def update_address_details_from_reverse_geocoding(results)
    if geo = results.first
      self.city = geo.city
      self.state_province = geo.state_code
      country = Country.find_country_by_name(geo.country_code) ||
                  Country.find_country_by_alpha3(geo.country_code) ||
                    Country.find_country_by_alpha2(geo.country_code)
      self.country = country.alpha2
    end
  end

  private
  def register_to_season
    if season_ids.empty?
      RegisterToSeasonJob.perform_later(self)
    end
  end

  class VirtualRegionalPitchEvent
    include ActiveModel::Conversion
    extend ActiveModel::Naming

    attr_accessor :id

    def self.model_name
      ActiveModel::Name.new(self, nil, "RegionalPitchEvent")
    end

    def persisted?
      true
    end

    def name; "Virtual (online) Judging"; end
    def name_with_friendly_country_prefix; name; end
    def live?; false; end
    def virtual?; true; end
    def unofficial?; false; end
    def id; "virtual"; end
    def city; "No city, all online"; end
    def venue_address; "No address, all online"; end
    def eventbrite_link; end

    def teams
      Team.not_attending_live_event
    end

    def team_submissions
      TeamSubmission.includes(team: :regional_pitch_events)
                    .references(:regional_pitch_events)
                    .where("regional_pitch_events.id IS NULL")
    end

    def timezone
      "US/Pacific"
    end

    def starts_at
      DateTime.new(2017, 5, 1, 7, 0, 0).in_time_zone(timezone)
    end

    def ends_at
      DateTime.new(2017, 5, 16, 6, 59, 59).in_time_zone(timezone)
    end

    def divisions
      [Division.junior, Division.senior]
    end
  end
end
