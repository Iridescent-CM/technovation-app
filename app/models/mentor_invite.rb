class MentorInvite < TeamMemberInvite
  belongs_to :invitee, class_name: "MentorAccount"

  scope :for_mentors, -> { where(invitee_id: MentorAccount.pluck(:id)) }

  delegate :first_name, to: :invitee, prefix: true

  def self.accept!(token, email = nil)
    if invite = where("invite_token = ? OR invitee_email = ?", token, email).first
      invite.update_attributes({
        status: :accepted,
        invitee: Account.find_by(email: email) || invite.invitee,
      })
      invite
    else
      false
    end
  end

  def after_accept
    team.add_mentor(invitee)
  end

  private
  def send_invite
    TeamMailer.invite_mentor(self).deliver_later
  end

  def set_invitee
    self.invitee ||= MentorAccount.find_by(email: invitee_email)
  end

  def correct_invitee_type
    if Account.where.not(type: "MentorAccount").where(email: invitee_email).any?
      errors.add(:invitee_email, :is_not_a_mentor)
    end
  end
end
