module RegisterStudent
  def self.call(student_account, context, invite = TeamMemberInvite, mailer = ParentMailer)
    if student_account.save
      mailer.consent_notice(student_account.parent_guardian_email,
                            student_account.consent_token).deliver_later
      invite.match_registrant(student_account)
      RegisterToCurrentSeasonJob.perform_later(student_account)
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
