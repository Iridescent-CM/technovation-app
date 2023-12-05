module Student
  class PaperConsentUploadsController < StudentController
    def update
      @parental_consent = current_student.parental_consent
      @media_consent = current_student.media_consent
      success_messages = []
      error_messages = []

      if parental_consent_params[:uploaded_consent_form].blank? && media_consent_params[:uploaded_consent_form].blank?
        error_messages << I18n.t("controllers.paper_consent_uploads.update.upload_missing")
      else
        if media_consent_params[:uploaded_consent_form].present?
          if @media_consent.update(media_consent_params)
            success_messages << I18n.t("controllers.paper_consent_uploads.update.media_consent.success")
          else
            error_messages << I18n.t("controllers.paper_consent_uploads.update.media_consent.error",
              max_file_size: "#{PaperParentalConsentUploader::MAXIMUM_UPLOAD_FILE_SIZE_IN_MEGABYTES} MB")
          end
        end

        if parental_consent_params[:uploaded_consent_form].present?
          if @parental_consent.update(parental_consent_params)
            success_messages << I18n.t("controllers.paper_consent_uploads.update.parental_consent.success")
          else
            error_messages << I18n.t("controllers.paper_consent_uploads.update.parental_consent.error",
              max_file_size: "#{PaperParentalConsentUploader::MAXIMUM_UPLOAD_FILE_SIZE_IN_MEGABYTES} MB")
          end
        end
      end

      if success_messages.size == 2
        success_messages = [I18n.t("controllers.paper_consent_uploads.update.parental_and_media_consent.success")]
      end

      if error_messages.size == 2
        error_messages = [
          I18n.t("controllers.paper_consent_uploads.update.parental_and_media_consent.error",
            max_file_size: "#{PaperParentalConsentUploader::MAXIMUM_UPLOAD_FILE_SIZE_IN_MEGABYTES} MB")
        ]
      end

      redirect_to student_dashboard_path,
        success: success_messages.presence&.join(""),
        error: error_messages.presence&.join("")
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
