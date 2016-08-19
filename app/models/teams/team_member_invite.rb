class TeamMemberInvite < ActiveRecord::Base
  enum status: %i{pending accepted rejected}

  before_create :generate_invite_token
  before_create :set_existing_invitee
  after_create :send_invite

  after_save :after_accept, if: -> { status_changed? && accepted? }

  belongs_to :team
  belongs_to :inviter, class_name: "Account"
  belongs_to :invitee, class_name: "StudentAccount"

  validates :invitee_email, presence: true, uniqueness: { scope: :team_id }

  validate -> {
    if StudentAccount.exists_on_team?(email: invitee_email)
      errors.add(:invitee_email, :already_on_team)
    end
  }

  validate :correct_invitee_type

  delegate :email, to: :inviter, prefix: true
  delegate :name, to: :team, prefix: true

  def to_param
    invite_token
  end

  def after_accept
    team.add_student(invitee)
  end

  def self.finish_acceptance(account, token)
    if invite = find_by(invitee_email: account.email, invite_token: token)
      invite.update_attributes(invitee_id: account.id)

      if invite.accepted?
        invite.after_accept
      end
    elsif invite = find_by(invitee_email: account.email)
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
