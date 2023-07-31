module Student
  class PaperConsentUploadsController < StudentController
    def update
      @parental_consent = current_student.parental_consent

      if @parental_consent.update(parental_consent_upload_params.merge(uploaded_at: Time.now))
        redirect_to student_dashboard_path, success: "Thank you for uploading your consent form, we will review it as soon as we can."
      else
        redirect_to student_dashboard_path, error: "The consent form needs to be an image or in PDF format. Please try again."
      end
    end

    private

    def parental_consent_upload_params
      params.require(:parental_consent).permit(
        :uploaded_consent_form
      )
    end
  end
end
