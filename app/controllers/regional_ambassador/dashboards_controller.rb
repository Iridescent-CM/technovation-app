module RegionalAmbassador
  class DashboardsController < RegionalAmbassadorController
    def show
      if current_ambassador.intro_summary.blank?
        current_ambassador.regional_links.build
      end

      @uploader = ImageUploader.new
      @uploader.success_action_redirect =
        regional_ambassador_profile_image_upload_confirmation_url(
          back: regional_ambassador_dashboard_path
        )
      render "regional_ambassador/dashboards/show_#{current_ambassador.status}"
    end
  end
end
