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

    private

    def grid_params
      grid = (params[:parental_consents_grid] ||= {}).merge(
        upload_approval_status: params[:parental_consents_grid][:upload_approval_status] || ParentalConsent::PAPER_CONSENT_UPLOAD_STATUSES[:pending],
        season: params[:parental_consents_grid][:season] || Season.current.year
      )

      grid.merge(
        column_names: detect_extra_columns(grid)
      )
    end
  end
end
