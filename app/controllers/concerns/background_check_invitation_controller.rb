module BackgroundCheckInvitationController
  def background_check_invitation
    RequestCheckrBackgroundCheckInvitationJob.perform_later(candidate: current_profile)

    redirect_to send("#{current_scope}_dashboard_path"),
      success: t("controllers.background_checks.invite.success")
  end
end
