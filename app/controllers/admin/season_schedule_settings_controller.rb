module Admin
  class SeasonScheduleSettingsController < AdminController
    def update
      season_toggle_params.each do |key, value|
        SeasonToggles.public_send("#{key}=", value)
      end
      redirect_to admin_dashboard_path, success: "Season schedule saved!"
    end

    private
    def season_toggle_params
      params.require(:season_toggles).permit(
        *signup_scopes
      )
    end

    def signup_scopes
      %w{student mentor judge regional_ambassador}.map do |scope|
        "#{scope}_signup"
      end
    end
  end
end
