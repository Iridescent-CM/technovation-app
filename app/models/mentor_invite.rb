class MentorInvite < TeamMemberInvite
  default_scope -> { where(invitee_type: "MentorProfile") }

  def after_accept
    TeamRosterManaging.add(team, invitee)
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
     unless Account.joins(:mentor_profile)
       .where("lower(email) = ?", invitee_email.downcase)
       .exists?
      errors.add(:invitee_email, :is_not_a_mentor)
     end
  end
end
