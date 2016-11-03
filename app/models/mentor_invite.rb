class MentorInvite < TeamMemberInvite
  default_scope -> { where(invitee_type: "MentorProfile") }

  delegate :first_name, to: :invitee, prefix: true

  def after_accept
    team.add_mentor(invitee)
  end

  private
  def send_invite
    TeamMailer.invite_mentor(self).deliver_later
  end

  def set_invitee
    self.invitee_id ||= Account.where("lower(email) = ?", invitee_email.downcase).first.id
    self.invitee_type ||= "MentorProfile"
  end
end
