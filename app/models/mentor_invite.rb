class MentorInvite < TeamMemberInvite
  belongs_to :invitee, class_name: "MentorAccount"

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

  def set_existing_invitee
    self.invitee ||= MentorAccount.find_by(email: invitee_email)
    true
  end
end
