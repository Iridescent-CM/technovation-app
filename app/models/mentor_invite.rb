class MentorInvite < TeamMemberInvite
  belongs_to :invitee, class_name: "MentorAccount"

  def after_accept
    team.add_mentor(invitee)
  end

  private
  def send_invite
    TeamMailer.invite_mentor(self).deliver_later
  end

  def set_existing_invitee
    self.invitee ||= MentorAccount.find_by(email: invitee_email)
    true
  end
end
