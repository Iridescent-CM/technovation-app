module Admin
  class PaperParentalConsentsController < AdminController
    def create
      student = StudentProfile.find(params[:id])

      student.student_profile.update(parent_guardian_name: "ON FILE",
                                     parent_guardian_email: "ON FILE")

      consent = ParentalConsent.where(student_profile_id: params[:id]).last

      consent.update(
        status: ParentalConsent.statuses[:signed],
        electronic_signature: "ON FILE"
      )

      consent.after_signed_student_actions

      redirect_to admin_participant_path(student.account),
        success: "#{student.full_name} has their paper parental consent on file."
    end
  end
end
