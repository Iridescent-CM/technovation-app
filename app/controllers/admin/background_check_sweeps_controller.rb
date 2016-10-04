require "rake"

module Admin
  class BackgroundCheckSweepsController < AdminController
    def create
      SweepBackgroundChecksJob.perform_later("pending", "consider")
      redirect_to :back, success: "All pending and consider BG Checks are being synced. Reload in a minute."
    end
  end
end
