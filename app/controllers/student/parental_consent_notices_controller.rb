class Student::ParentalConsentNoticesController < StudentController
  def create
    ParentMailer.consent_notice(current_student.parent_guardian_email,
                                current_student.consent_token).deliver_later
    redirect_to :back
  end
end
