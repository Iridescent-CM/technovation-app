class TeamMemberInvite < ActiveRecord::Base
  enum status: %i{pending accepted declined deleted}

  scope :for_students, -> {
    where("invitee_id IS NULL OR invitee_type = ?", "StudentProfile")
  }

  has_secure_token :invite_token

  before_create :set_invitee
  after_commit :send_invite, on: :create

  after_save :after_accept, if: -> { status_changed? && accepted? }

  belongs_to :team, touch: true
  belongs_to :inviter, polymorphic: true
  belongs_to :invitee, polymorphic: true

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
    team.add_student(invitee)
    pending = self.class.where(invitee_email: invitee_email,
                               status: self.class.statuses[:pending])
    pending.each(&:declined!)
  end

  def can_be_accepted?
    invitee.can_join_a_team?
  end

  def cannot_be_accepted?
    not can_be_accepted?
  end

  def self.match_registrant(profile)
    where(invitee_email: profile.email).each do |invite|
      invite.update_attributes(invitee: profile)
    end
  end

  private
  def set_invitee
    if student = StudentProfile.joins(:account).where("lower(accounts.email) = ?", invitee_email.downcase).first
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
