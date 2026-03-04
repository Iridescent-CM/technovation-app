class MentorInvite < TeamMemberInvite
  default_scope -> { where(invitee_type: "MentorProfile") }

  enum decline_reason: %i[timezone_concern already_mentoring unavailable]
  validates :decline_reason, presence: true, if: :declined?

  def after_accept
    TeamRosterManaging.add(team, invitee)
  end

  private

  def send_invite
    if invitee.present?
      TeamMailer.invite_mentor(self).deliver_later
    else
      TeamMailer.invite_member(self).deliver_later
    end
  end

  def set_invitee
    if mentor_profile.present?
      self.invitee = mentor_profile
    end
  end

  def correct_invitee_type
  end

  def mentor_profile
    @mentor_profile ||= MentorProfile
      .joins(:account)
      .where("lower(accounts.email) = ?", invitee_email.downcase)
      .first
  end
end
