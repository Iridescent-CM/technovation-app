class MentorInvite < TeamMemberInvite
  default_scope -> { where(invitee_type: "MentorAccount") }

  delegate :first_name, to: :invitee, prefix: true

  def after_accept
    team.add_mentor(invitee)
  end

  private
  def send_invite
    TeamMailer.invite_mentor(self).deliver_later
  end

  def set_invitee
    self.invitee_id ||= MentorAccount.where("lower(email) = ?", invitee_email.downcase).first.id
    self.invitee_type ||= "MentorAccount"
  end

  def correct_invitee_type
    if Account.where.not(type: "MentorAccount").where("lower(email) = ?", invitee_email.downcase).any?
      errors.add(:invitee_email, :is_not_a_mentor)
    end
  end
end
