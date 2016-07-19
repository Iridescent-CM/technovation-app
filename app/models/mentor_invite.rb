class MentorInvite < TeamMemberInvite
  private
  def send_invite
    TeamMailer.invite_mentor(self).deliver_later
  end
end
