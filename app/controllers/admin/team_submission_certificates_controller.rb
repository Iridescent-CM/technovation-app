module Admin
  class TeamSubmissionCertificatesController < AdminController
    def update
      ExportCertificates.(params[:id], params[:type])
      redirect_back fallback_location: admin_team_submissions_path,
        success: "Certificates are being generated. Reload in a moment to get new links."
    end
  end
end
