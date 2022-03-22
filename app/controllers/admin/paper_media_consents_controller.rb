module Admin
  class PaperMediaConsentsController < AdminController
    def create
        student = StudentProfile.find(params[:id])
        if student.media_consent.present? && !student.media_consent.consent_provided?
            consent = student.media_consent
            consent.update(
                consent_provided: true,
                electronic_signature: "ON FILE",
                signed_at: DateTime.current
            )

            redirect_to admin_participant_path(student.account),
            success: "#{student.full_name} has their media consent on file."
        end
    end
  end
end
