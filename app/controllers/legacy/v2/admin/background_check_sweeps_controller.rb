require "rake"

module Admin
  class BackgroundCheckSweepsController < AdminController
    def create
      SweepBackgroundChecksJob.perform_later("pending", "consider", "suspended")
      redirect_back fallback_location: admin_background_checks_path,
        success: "All pending, consider, and suspended BG Checks are being synced. Reload in a minute."
    end
  end
end
