require 'obscenity/active_model'

class Team < ActiveRecord::Base
  mount_uploader :team_photo, TeamPhotoProcessor

  scope :current, -> { eager_load(season_registrations: :season)
                       .where("seasons.year = ?", Season.current.year) }

  scope :past, -> { eager_load(season_registrations: :season)
                    .where.not(id: current.map(&:id).uniq) }

  scope :without_mentor, -> {
    where.not(id: Membership.where(member_type: "MentorAccount").map(&:joinable_id))
  }

  after_create :register_to_season

  has_many :season_registrations, as: :registerable
  has_many :seasons, through: :season_registrations

  belongs_to :division

  has_many :memberships, as: :joinable, dependent: :destroy
  has_many :students, -> { eager_load(:memberships).order("memberships.created_at") }, through: :memberships, source: :member, source_type: "StudentAccount"
  has_many :mentors, -> { eager_load(:memberships).order("memberships.created_at") }, through: :memberships, source: :member, source_type: "MentorAccount"

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
    memberships.first.member_address_details
  end

  def city
    memberships.first && memberships.first.member_city
  end

  def state_province
    memberships.first && memberships.first.member_state_province
  end

  def country
    memberships.first &&
      Country[memberships.first.member_country].name
  end

  def pending_invitee_emails
    team_member_invites.pending.flat_map(&:invitee_email)
  end

  def add_mentor(mentor)
    if !!mentor and not mentors.include?(mentor)
      mentors << mentor
      save
    end
  end

  def add_student(student)
    if !!student and not students.include?(student) and spot_available?
      students << student
      reconsider_division
    end
  end

  def remove_student(student)
    membership = Membership.find_by(joinable: self,
                                    member_type: "StudentAccount",
                                    member_id: student.id)
    membership.destroy
    reconsider_division
  end

  def reconsider_division
    self.division = Division.for(self)
    save
  end

  def current?
    seasons.include?(Season.current)
  end

  def invited_mentor?(mentor)
    mentor_invites.pending.where(invitee_id: mentor.id, invitee_type: "MentorAccount").any?
  end

  def after_registration
  end

  private
  def register_to_season
    if season_ids.empty?
      RegisterToSeasonJob.perform_later(self)
    end
  end
end
