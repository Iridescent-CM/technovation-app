module RegisterStudent
  def self.call(student_account, context, invite = TeamMemberInvite)
    student_account.student_profile.made_with_code = context.get_cookie(:made_with_code)

    if student_account.save
      invite.match_registrant(student_account)
      true
    else
      false
    end
  end

  def self.build(account, attributes)
    student = account.new(attributes)
    student.build_student_profile if student.student_profile.blank?
    student
  end
end
