module Student
  class PaperConsentUploadsController < StudentController
    def update
      @parental_consent = current_student.parental_consent
      @media_consent = current_student.media_consent

      if params[:parental_consent].blank?
        redirect_to student_dashboard_path, error: "You forgot to upload a consent form. Please try again."
      elsif @parental_consent.update(parental_consent_params) && @media_consent.update(media_consent_params)
        redirect_to student_dashboard_path, success: "Thank you for uploading your consent form, we will review it as soon as we can."
      else
        redirect_to student_dashboard_path, error: "The consent forms need to be an image or in PDF format, and less than #{PaperParentalConsentUploader::MAXIMUM_UPLOAD_FILE_SIZE_IN_MEGABYTES} MB. Please try again."
      end
    end

    private

    def parental_consent_params
      {uploaded_consent_form: params.dig(:parental_consent, :uploaded_consent_form)}
    end

    def media_consent_params
      {uploaded_consent_form: params.dig(:parental_consent, :media_consent, :uploaded_consent_form)}
    end
  end
end
