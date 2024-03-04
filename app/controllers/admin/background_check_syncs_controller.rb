module Admin
  class BackgroundCheckSyncsController < AdminController
    def create
      SyncBackgroundChecksJob.perform_later(admin_profile_id: current_admin.id)

      redirect_back fallback_location: admin_background_checks_path,
        success: "All uncleared background checks and all incomplete invitations are being synced. Reload in a minute."
    end
  end
end
