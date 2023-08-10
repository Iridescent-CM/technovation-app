module Admin
  class PaperParentalConsentsController < AdminController
    include DatagridController

    use_datagrid with: ParentalConsentsGrid

    def create
      student = StudentProfile.find(params[:id])
      parental_consent = student.parental_consent

      parental_consent.update(
        status: ParentalConsent.statuses[:signed],
        electronic_signature: ParentalConsent::PARENT_GUARDIAN_NAME_FOR_A_PAPER_CONSENT
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
      grid = (params[:parental_consents_grid] ||= {}).merge(
        upload_approval_status: params[:parental_consents_grid][:upload_approval_status] || ConsentForms::PAPER_CONSENT_UPLOAD_STATUSES[:pending],
        season: params[:parental_consents_grid][:season] || Season.current.year
      )

      grid.merge(
        column_names: detect_extra_columns(grid)
      )
    end
  end
end
