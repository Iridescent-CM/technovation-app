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
    self.invitee ||= MentorProfile
      .joins(:account)
      .where("lower(accounts.email) = ?", invitee_email.downcase)
      .first
  end

  # Overwriting parent validation
  def correct_invitee_type
    if Account.joins(:mentor_profile).where("lower(email) = ?", invitee_email.downcase).empty?
      errors.add(:invitee_email, :is_not_a_mentor)
    end
  end
end
