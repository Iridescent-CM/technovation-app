module BackgroundCheckInvitationController
  extend ActiveSupport::Concern

  included do
    before_action :verify_background_check_invitation_required, only: [:create_invitation]
  end

  def create_invitation
    RequestCheckrBackgroundCheckInvitationJob.perform_later(account_id: current_account.id)

    redirect_to send("#{current_scope}_dashboard_path"),
      success: t("controllers.background_checks.invite.success")
  end

  private

  def verify_background_check_invitation_required
    unless current_profile.in_background_check_invitation_country? &&
        (current_profile.background_check.blank? || current_profile.background_check.invitation_expired? || current_profile.background_check.error?)
      redirect_to send("#{current_scope}_dashboard_path"),
                  alert: t("controllers.application.unauthorized")
    end
  end
end
