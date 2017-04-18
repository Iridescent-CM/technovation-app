class Team < ActiveRecord::Base
  include Elasticsearch::Model

  index_name "#{Rails.env}_teams"
  document_type 'team'
  settings index: { number_of_shards: 1, number_of_replicas: 1 }

  before_create :update_geocoding
  reverse_geocoded_by :latitude, :longitude

  after_destroy { IndexModelJob.perform_later("delete", "Team", id) }

  after_commit :register_to_season, on: :create

  after_save -> {
    submission.touch if submission.present?
  }, if: :submission_completeness_could_change?

  def submission_completeness_could_change?()
    team_photo_changed? or division_id_changed?
  end

  def as_indexed_json(options = {})
    as_json(
      only: %w{id name description spot_available?},
      methods: :spot_available?
    )
  end

  def type_name
    "student" # TODO this is a big mistake -- using it for RPE selection
  end

  def photo
    team_photo
  end

  mount_uploader :team_photo, TeamPhotoProcessor

  scope :current, -> {
    joins(season_registrations: :season)
    .where("seasons.year = ?", Season.current.year)
  }

  scope :junior, -> {
    joins(:division).where("divisions.name = ?", Division.names[:junior])
  }

  scope :senior, -> {
    joins(:division).where("divisions.name = ?", Division.names[:senior])
  }

  scope :past, -> {
    eager_load(season_registrations: :season)
    .where.not(id: current.map(&:id).uniq)
  }

  scope :without_mentor, -> {
    where.not(id: Membership.where(member_type: "MentorProfile").map(&:joinable_id))
  }

  scope :for_ambassador, ->(ambassador) {
    students = []
    mentors = []

    if ambassador.country == "US"
      students = StudentProfile.joins(:account).includes(:teams)
        .where("accounts.state_province = ? AND accounts.country = 'US'",
               ambassador.state_province)

      mentors = MentorProfile.joins(:account).includes(:teams)
        .where("accounts.state_province = ? AND accounts.country = 'US'",
               ambassador.state_province)
    else
      students = StudentProfile.joins(:account).includes(:teams)
        .where("accounts.country = ?", ambassador.country)

      mentors = MentorProfile.joins(:account).includes(:teams)
        .where("accounts.country = ?", ambassador.country)
    end

    where(id: (students + mentors).flat_map(&:teams).uniq.map(&:id))
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

  has_and_belongs_to_many :regional_pitch_events, -> { uniq },
    after_add: :update_submission, after_remove: :update_submission

  def update_submission(o)
    submission.touch if submission.present?
  end

  has_one :judge_assignment

  validates :name, uniqueness: { case_sensitive: false }, presence: true
  validates :description, presence: true
  validates :division, presence: true
  validates :team_photo, verify_cached_file: true

  delegate :name, to: :division, prefix: true

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
    if %w{Brasil Brazil}.include?(creator.state_province || "")
      "Brazil"
    elsif creator.country == "US"
      Country["US"].states[creator.state_province.strip]['name']
    else
      creator.get_country
    end
  end

  def region_division_name
    Rails.cache.fetch("#{cache_key}/region_division_name") do
      name = creator.country || ""
      if name == "US"
        name += "_#{state_province}"
      end
      name += ",#{division.name}"
    end
  end

  def junior?
    division.junior?
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

  def creator_address_details
    creator.address_details
  end

  def primary_location
    creator_address_details
  end

  def city
    creator.city
  end

  def state_province
     creator.state_province
  end

  def country
    creator && creator.get_country
  end

  def creator
    members.first || NullCreator.new
  end

  def pending_invitee_emails
    team_member_invites.pending.flat_map(&:invitee_email)
  end

  def add_mentor(mentor)
    if !!mentor and not mentors.include?(mentor)
      mentors << mentor
      update_geocoding if mentor == creator
      save
    end
  end

  def add_student(student)
    if !!student and not students.include?(student) and spot_available?
      students << student
      update_geocoding if student == creator
      reconsider_division
      save
    end
  end

  def remove_student(student)
    membership = Membership.find_by(joinable: self,
                                    member_type: "StudentProfile",
                                    member_id: student.id)
    membership.destroy
    reconsider_division
    save
  end

  def remove_mentor(mentor)
    membership = Membership.find_by(joinable: self,
                                    member_type: "MentorProfile",
                                    member_id: mentor.id)
    membership.destroy
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
    team_submissions.current.last or
      StudentProfile::NullTeam::NullTeamSubmission.new
  end

  def unassigned?
    not assigned?
  end

  def assigned?
    judge_assignment.present?
  end

  def assigned_judge
    judge_assignment.judge_profile
  end

  def assigned_judge_name
    assigned_judge.full_name
  end

  class NullCreator
    def address_details; end
    def latitude; end
    def longitude; end
    def city; end
    def state_province; end
    def country; end
    def get_country; end

    def present?
      false
    end

    def cache_key
      "null key"
    end
  end

  private
  def update_geocoding
    self.latitude = creator.latitude
    self.longitude = creator.longitude
  end

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
    def live?; false; end
    def id; "virtual"; end
    def city; "No city, all online"; end
    def venue_address; "No address, all online"; end
    def eventbrite_link; end
    def teams; []; end

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
