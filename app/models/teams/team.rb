class Team < ActiveRecord::Base
  scope :current, -> { joins(season_registrations: :season).where("seasons.year = ?", CurrentSeasonYear.()) }
  scope :past, -> { joins(season_registrations: :season).where("seasons.year < ?", CurrentSeasonYear.()) }

  after_create :register_to_current_season

  has_many :season_registrations, as: :registerable
  has_many :seasons, through: :season_registrations

  belongs_to :division

  has_many :memberships, as: :joinable, dependent: :destroy
  has_many :students, through: :memberships, source: :member, source_type: "StudentAccount"
  has_many :mentors, through: :memberships, source: :member, source_type: "MentorAccount"

  has_many :submissions, dependent: :destroy

  has_many :team_member_invites, dependent: :destroy
  has_many :join_requests, as: :joinable, dependent: :destroy

  has_many :pending_invites, -> { pending }, class_name: "TeamMemberInvite"
  has_many :pending_requests, -> { pending }, class_name: "JoinRequest", as: :joinable

  validates :name, uniqueness: { case_sensitive: false }, presence: true
  validates :description, presence: true
  validates :division, presence: true

  def student_emails
    students.flat_map(&:email)
  end

  def mentor_emails
    mentors.flat_map(&:email)
  end

  def creator_address_details
    memberships.first.member_address_details
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
    if !!student and not students.include?(student)
      students << student
      save
    end
  end

  private
  def register_to_current_season
    RegisterToCurrentSeasonJob.perform_later(self)
  end
end
