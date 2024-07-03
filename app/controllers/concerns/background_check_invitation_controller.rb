module BackgroundCheckInvitationController
  extend ActiveSupport::Concern

  def create_invitation

    result = CheckrApiClient::BackgroundCheckInvitationValidator.new(account: current_account).call

    if result.error?
      redirect_to send("#{current_scope}_dashboard_path"),
        alert: result.error_message
    elsif result.requires_background_check_invitation?
      RequestCheckrBackgroundCheckInvitationJob.perform_later(account_id: current_account.id)
      redirect_to send("#{current_scope}_dashboard_path"),
        success: t("controllers.background_checks.invite.success")
    else
      redirect_to send("#{current_scope}_dashboard_path"),
        alert: t("controllers.application.unauthorized")
    end
  end
end
