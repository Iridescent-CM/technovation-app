module RegisterStudent
  def self.call(student_account, context)
    if student_account.save
      ParentMailer.consent_notice(student_account).deliver_later
      TeamMemberInvite.accept!(context.get_cookie(:team_invite_token), student_account.email)
      true
    else
      false
    end
  end

  def self.build(attributes)
    student = StudentAccount.new(attributes)
    student.build_student_profile if student.student_profile.blank?
    student
  end
end
