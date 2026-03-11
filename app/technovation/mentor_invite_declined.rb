module MentorInviteDeclined
  def self.call(invite)
    invite.team.students.each do |student|
      TeamMailer.mentor_invite_declined(student, invite).deliver_later
    end
  end
end
