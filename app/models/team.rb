require 'obscenity/active_model'

class Team < ActiveRecord::Base
  include Elasticsearch::Model

  index_name "#{Rails.env}_teams"
  document_type 'team'
  settings index: { number_of_shards: 1, number_of_replicas: 1 }

  before_create :update_geocoding
  reverse_geocoded_by :latitude, :longitude

  after_save    { IndexTeamJob.perform_later("index", id) }
  after_destroy { IndexTeamJob.perform_later("delete", id) }

  def as_indexed_json(options = {})
    as_json(only: %w{id name description})
  end

  mount_uploader :team_photo, TeamPhotoProcessor

  scope :current, -> {
    joins(season_registrations: :season)
    .where("seasons.year = ?", Season.current.year)
  }

  scope :past, -> {
    eager_load(season_registrations: :season)
    .where.not(id: current.map(&:id).uniq)
  }

  scope :without_mentor, -> {
    where.not(id: Membership.where(member_type: "MentorProfile").map(&:joinable_id))
  }

  scope :accepting_mentor_requests, -> { where(accepting_mentor_requests: true) }

  scope :accepting_student_requests, -> { where(accepting_student_requests: true) }

  after_commit :register_to_season, on: :create

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

  validates :name, uniqueness: { case_sensitive: false }, presence: true
  validates :description, presence: true
  validates :division, presence: true
  validates :team_photo, verify_cached_file: true
  validates :name, :description,  obscenity: { sanitize: true, replacement: "[censored]" }

  delegate :name, to: :division, prefix: true

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
    (students + pending_student_invites + join_requests.pending.select { |j| j.requestor.type_name == 'student' }).size < 5
  end

  def creator_address_details
    creator.address_details
  end

  def city
    creator.city
  end

  def state_province
     creator.state_province
  end

  def country
    Country[creator.country].name if creator.present?
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
    team_submissions.current.last
  end

  class NullCreator
    def address_details; end
    def latitude; end
    def longitude; end
    def city; end
    def state_province; end
    def country; end

    def present?
      false
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
end
