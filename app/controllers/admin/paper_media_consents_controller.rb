module Admin
  class PaperMediaConsentsController < AdminController
    include DatagridController

    use_datagrid with: MediaConsentsGrid

    def create
      student = StudentProfile.find(media_consent_params[:id])
      if student.media_consent.present? && !student.media_consent.consent_provided?
        consent = student.media_consent
        consent.update(
          consent_provided: media_consent_params[:consent],
          electronic_signature: ConsentForms::ELECTRONIC_SIGNATURE_FOR_A_PAPER_CONSENT,
          signed_at: DateTime.current
        )

        redirect_to admin_participant_path(student.account),
          success: "#{student.full_name} has their media consent on file."
      end
    end

    def approve
      media_consent = MediaConsent.find(params[:paper_media_consent_id])

      media_consent.update(
        electronic_signature: ConsentForms::ELECTRONIC_SIGNATURE_FOR_A_PAPER_CONSENT,
        signed_at: Time.now,
        consent_provided: params[:consent_provided] == "true",
        upload_approved_at: Time.now,
        upload_approval_status: ConsentForms::PAPER_CONSENT_UPLOAD_STATUSES[:approved]
      )

      redirect_to admin_paper_media_consents_path,
        success: "You approved the media consent for #{media_consent.student_profile_full_name}."
    end

    def reject
      media_consent = MediaConsent.find(params[:paper_media_consent_id])

      media_consent.update(
        upload_rejected_at: Time.now,
        upload_approval_status: ConsentForms::PAPER_CONSENT_UPLOAD_STATUSES[:rejected]
      )

      redirect_to admin_paper_media_consents_path,
        success: "You rejected the media consent for #{media_consent.student_profile_full_name}."
    end

    private

    def media_consent_params
      params.permit(
        :id,
        :consent
      )
    end

    def grid_params
      grid = (params[:media_consents_grid] ||= {}).merge(
        upload_approval_status: params[:media_consents_grid][:upload_approval_status] || ConsentForms::PAPER_CONSENT_UPLOAD_STATUSES[:pending],
        season: params[:media_consents_grid][:season] || Season.current.year
      )

      grid.merge(
        column_names: detect_extra_columns(grid)
      )
    end
  end
end
