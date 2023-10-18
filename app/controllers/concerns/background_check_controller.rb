module BackgroundCheckController
  extend ActiveSupport::Concern

  included do
    before_action :verify_background_check_invitation_required, only: [:international_background_check]
  end

  def new
    if current_profile.background_check_candidate_id.present?
      redirect_to send("#{current_scope}_background_check_path", id: current_profile.background_check_candidate_id)
    else
      @candidate = BackgroundCheckCandidate.new(account: current_account)
    end
  end

  def show
    if current_profile.background_check.invitation_id.present?
      InvitationChecking.new(current_profile).execute
    end

    if current_profile.background_check.report_id.present?
      BackgroundChecking.new(current_profile.background_check).execute
    end
    @background_check = current_profile.background_check
  end

  def create
    @candidate = BackgroundCheckCandidate.new(candidate_params)

    if @candidate.submit
      current_profile.account.update(background_check_attributes: {
        candidate_id: @candidate.id,
        report_id: @candidate.report_id
      })
      redirect_to send("#{current_scope}_dashboard_path"),
        success: "Thank you for submitting your background check."
    else
      render :new
    end
  end

  private
  def candidate_params
    params.require(:background_check_candidate).permit(
      :first_name,
      :middle_name,
      :last_name,
      :email,
      :zipcode,
      :date_of_birth,
      :ssn,
      :driver_license_state,
      :copy_requested
    ).tap do |tapped|
      tapped[:driver_license_state] = tapped[:driver_license_state].strip.upcase
    end
  end

  def verify_background_check_invitation_required
    unless current_profile.in_background_check_invitation_country? &&
        (current_profile.background_check.blank? || current_profile.background_check.invitation_expired?)
      redirect_to send("#{current_scope}_dashboard_path"),
                  alert: t("controllers.application.unauthorized")
    end
  end
end
