module BackgroundCheckController
  def show
    if current_profile.background_check.invitation_id.present?
      InvitationChecking.new(current_account).execute
    end

    if current_profile.background_check.report_id.present?
      BackgroundChecking.new(current_profile.background_check).execute
    end
    @background_check = current_profile.background_check
  end
end
