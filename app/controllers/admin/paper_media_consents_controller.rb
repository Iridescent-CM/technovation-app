module Admin 
  class PaperMediaConsentsController < AdminController

    def create
      student = StudentProfile.find(media_consent_params[:id])
      if student.media_consent.present? && !student.media_consent.consent_provided?
        consent = student.media_consent
        consent.update(
          consent_provided: media_consent_params[:consent],
          electronic_signature: MediaConsent::ELECTRONIC_SIGNATURE_FOR_A_PAPER_MEDIA_CONSENT,
          signed_at: DateTime.current
        )

        redirect_to admin_participant_path(student.account),
        success: "#{student.full_name} has their media consent on file."
      end
    end

    private

    def media_consent_params
      params.permit(
        :id,
        :consent
      )
    end
  end
end
