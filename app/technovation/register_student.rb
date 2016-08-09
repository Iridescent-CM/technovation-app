module RegisterStudent
  def self.call(student_account, context, mailer = ParentMailer)
    if student_account.save
      mailer.consent_notice(student_account).deliver_later
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
