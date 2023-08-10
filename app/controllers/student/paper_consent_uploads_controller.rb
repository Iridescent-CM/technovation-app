module Student
  class PaperConsentUploadsController < StudentController
    def update
      @parental_consent = current_student.parental_consent
      @media_consent = current_student.media_consent

      if @parental_consent.update(parental_consent_params) && @media_consent.update(media_consent_params)
        redirect_to student_dashboard_path, success: "Thank you for uploading your consent form, we will review it as soon as we can."
      else
        redirect_to student_dashboard_path, error: "The consent forms need to be an image or in PDF format, and less than #{PaperParentalConsentUploader::MAXIMUM_UPLOAD_FILE_SIZE_IN_MEGABYTES} MB. Please try again."
      end
    end

    private

    def parental_consent_params
      params.require(:parental_consent).permit(
        :uploaded_consent_form,
        media_consent: [:uploaded_consent_form]
      ).except(:media_consent).merge(uploaded_at: Time.now)
    end

    def media_consent_params
      params.require(:parental_consent).permit(
        :uploaded_consent_form,
        media_consent: [:uploaded_consent_form]
      ).except(:uploaded_consent_form)[:media_consent].merge(uploaded_at: Time.now)
    end
  end
end
