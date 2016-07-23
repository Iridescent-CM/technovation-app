class StudentAccount < Account
  default_scope { joins(:student_profile) }

  attr_accessor :team_invite_token

  after_initialize :build_student_profile, if: -> { student_profile.blank? }
  after_save :join_invited_team, on: :create
  after_save :send_parental_consent_notice, on: :create

  has_many :memberships, as: :member, dependent: :destroy
  has_many :mentor_invites, foreign_key: :inviter_id

  has_one :parental_consent, dependent: :destroy, foreign_key: :account_id

  has_one :student_profile, dependent: :destroy, foreign_key: :account_id
  accepts_nested_attributes_for :student_profile
  validates_associated :student_profile

  delegate :is_in_secondary_school?,
           :is_in_secondary_school,
           :parent_guardian_email,
           :parent_guardian_name,
           :school_name,
           :completion_requirements,
    to: :student_profile,
    prefix: false

  delegate :electronic_signature,
           :signed_at,
    to: :parental_consent,
    prefix: true

  def is_on_team?
    teams.any?
  end

  def team
    teams.first
  end

  def team_id
    team.id
  end

  def team_name
    team.name
  end

  def team_names
    teams.collect(&:name)
  end

  def teams
    Team.joins(:memberships).where("memberships.member_id = ?", id)
  end

  def invited_mentor?(mentor)
    mentor_invites.flat_map(&:invitee).include?(mentor)
  end

  private
  def send_parental_consent_notice
    ParentMailer.consent_notice(self).deliver_later
  end

  def join_invited_team
    TeamMemberInvite.accept!(team_invite_token, email)
  end
end
