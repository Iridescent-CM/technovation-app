module Admin
  class PaperParentalConsentsController < AdminController
    include DatagridController

    use_datagrid with: ParentalConsentsGrid

    def create
      student = StudentProfile.find(params[:id])
      parental_consent = student.parental_consent

      parental_consent.update(
        status: ParentalConsent.statuses[:signed],
        electronic_signature: ConsentForms::PARENT_GUARDIAN_NAME_FOR_A_PAPER_CONSENT
      )

      redirect_to admin_participant_path(student.account),
        success: "#{student.full_name} has their paper parental consent on file."
    end

    def approve
      parental_consent = ParentalConsent.find(params[:paper_parental_consent_id])

      parental_consent.update(
        status: ParentalConsent.statuses[:signed],
        electronic_signature: ConsentForms::PARENT_GUARDIAN_NAME_FOR_A_PAPER_CONSENT,
        upload_approved_at: Time.now,
        upload_approval_status: ConsentForms::PAPER_CONSENT_UPLOAD_STATUSES[:approved]
      )

      redirect_to admin_paper_parental_consents_path,
        success: "You approved the parental consent for #{parental_consent.student_profile_full_name}."
    end

    def reject
      parental_consent = ParentalConsent.find(params[:paper_parental_consent_id])

      parental_consent.update(
        upload_rejected_at: Time.now,
        upload_approval_status: ConsentForms::PAPER_CONSENT_UPLOAD_STATUSES[:rejected]
      )

      redirect_to admin_paper_parental_consents_path,
        success: "You rejected the parental consent for #{parental_consent.student_profile_full_name}."
    end

    private

    def grid_params
      permitted = permitted_grid_params
      grid = permitted.merge(
        admin: true,
        season: permitted[:season] || Season.current.year,
        country: Array(permitted[:country]),
        state_province: Array(permitted[:state_province])
      )

      if request.format.html?
        grid[:upload_approval_status] = grid[:upload_approval_status] || ConsentForms::PAPER_CONSENT_UPLOAD_STATUSES[:pending]
      end

      grid.merge(
        column_names: detect_extra_columns(grid)
      )
    end
  end
end
