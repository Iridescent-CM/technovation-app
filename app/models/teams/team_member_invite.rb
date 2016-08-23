class TeamMemberInvite < ActiveRecord::Base
  enum status: %i{pending accepted rejected}

  scope :for_students, -> { where("invitee_id IS NULL OR invitee_id NOT IN (?)", MentorAccount.pluck(:id)) }

  before_create -> { GenerateToken.(self, :invite_token) }
  before_create :set_invitee
  after_create :send_invite

  after_save :after_accept, if: -> { status_changed? && accepted? }

  belongs_to :team
  belongs_to :inviter, class_name: "Account"
  belongs_to :invitee, class_name: "StudentAccount"

  validates :invitee_email, presence: true

  validate -> {
    if self.class.exists?(invitee_email: invitee_email,
                          team_id: team_id,
                          status: self.class.statuses[:pending])
      errors.add(:invitee_email, :taken)
    end
  }, on: :create

  validate -> {
    if StudentAccount.exists_on_team?(email: invitee_email)
      errors.add(:invitee_email, :already_on_team)
    end
  }, on: :create

  validate -> {
    if StudentAccount.has_requested_to_join?(team, invitee_email)
      errors.add(:invitee_email, :already_requested_to_join)
    end
  }, on: :create

  validate :correct_invitee_type

  delegate :email, to: :inviter, prefix: true
  delegate :name, to: :team, prefix: true

  def to_param
    invite_token
  end

  def after_accept
    team.add_student(invitee)
    pending = self.class.where(invitee_email: invitee_email,
                               status: self.class.statuses[:pending])
    pending.each(&:rejected!)
  end

  def self.match_registrant(account)
    where(invitee_email: account.email).each do |invite|
      invite.update_attributes(invitee_id: account.id)
    end
  end

  private
  def correct_invitee_type
    if Account.where.not(type: "StudentAccount").where(email: invitee_email).any?
      errors.add(:invitee_email, :is_not_a_student)
    end
  end

  def set_invitee
    self.invitee ||= StudentAccount.find_by(email: invitee_email)
  end

  def send_invite
    TeamMailer.invite_member(self).deliver_later
  end
end
