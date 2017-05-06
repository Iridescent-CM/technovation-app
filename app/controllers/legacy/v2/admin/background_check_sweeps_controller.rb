module Legacy
  module V2
    module Admin
      class BackgroundCheckSweepsController < AdminController
        def create
          SweepBackgroundChecksJob.perform_later("pending", "consider", "suspended")
          redirect_back fallback_location: legacy_v2_admin_background_checks_path,
            success: "All pending, consider, and suspended BG Checks are being synced. Reload in a minute."
        end
      end
    end
  end
end
