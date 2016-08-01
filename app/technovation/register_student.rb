module RegisterStudent
  def self.call(student_account, context)
    if student_account.save
      mailer.consent_notice(student_account).deliver_later
      invite.accept!(context.get_cookie(:team_invite_token), student_account.email)
      true
    else
      false
    end
  end

  def self.build(attributes)
    student = account.new(attributes)
    student.build_student_profile if student.student_profile.blank?
    student
  end

  def self.invite
    TeamMemberInvite
  end

  def self.mailer
    ParentMailer
  end

  def self.account
    StudentAccount
  end
end
