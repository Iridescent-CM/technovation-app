class TeamMemberInvite < ActiveRecord::Base
  enum status: %i{pending accepted declined deleted}

  scope :for_students, -> {
    where("invitee_type IS NULL OR invitee_type = ?", "StudentProfile")
  }

  has_secure_token :invite_token

  before_validation :set_invitee
  after_commit :send_invite, on: :create

  after_save :after_accept, if: -> { saved_change_to_status? && accepted? }

  belongs_to :team, touch: true
  belongs_to :inviter, polymorphic: true
  belongs_to :invitee, polymorphic: true, required: false

  validates :invitee_email, presence: true, email: true

  validate -> {
    if self.class.exists?(invitee_email: invitee_email,
                          team_id: team_id,
                          status: self.class.statuses[:pending])
      errors.add(:invitee_email, :taken)
    end
  }, on: :create

  validate -> {
    if StudentProfile.exists_on_team?(invitee_email)
      errors.add(:invitee_email, :already_on_team)
    end
  }, on: :create

  validate -> {
    if StudentProfile.has_requested_to_join?(team, invitee_email)
      errors.add(:invitee_email, :already_requested_to_join)
    end
  }, on: :create

  validate :correct_invitee_type, on: :create

  delegate :email, to: :inviter, prefix: true

  delegate :name, to: :team, prefix: true

  delegate :first_name,
           :last_name,
           :scope_name,
           :mailer_token,
    to: :invitee, prefix: true

  def self.students_sending_invites_enabled?(important_dates: ImportantDates)
    (important_dates.official_start_of_season..important_dates.submission_deadline).cover?(Date.today)
  end

  def to_param
    invite_token
  end

  def invitee_name
    if !!invitee
      invitee.first_name
    else
      invitee_email
    end
  end

  def after_accept
    self.class.where(
      invitee_email: invitee_email,
      status: self.class.statuses[:pending]
    ).each(&:declined!)
  end

  def can_be_accepted?
    invitee.can_join_a_team?
  end

  def cannot_be_accepted?
    not can_be_accepted?
  end

  def self.match_registrant(profile)
    where(invitee_email: profile.email).each do |invite|
      invite.update(invitee: profile)
    end
  end

  private
  def set_invitee
    self.invitee_email = invitee_email.strip.downcase
    if student = StudentProfile.joins(:account)
                   .where("lower(trim(both ' ' from accounts.email)) = ?", invitee_email)
                   .first
      self.invitee = student
    end
  end

  def send_invite
    TeamMailer.invite_member(self).deliver_later
  end

  def correct_invitee_type
    if Account.where("lower(email) = ?", invitee_email.downcase).any? { |a| not a.student_profile.present? }
      errors.add(:invitee_email, :is_not_a_student)
    end
  end
end
