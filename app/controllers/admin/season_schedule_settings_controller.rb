module Admin
  class SeasonScheduleSettingsController < AdminController
    def update
      SeasonToggles.configure(season_toggle_params)
      redirect_to admin_dashboard_path, success: "Season schedule saved!"
    end

    private
    def season_toggle_params
      params.require(:season_toggles).permit(
        *signup_scopes,
        *dashboard_text_scopes,
        :team_submissions_editable,
        :select_regional_pitch_event,
        :display_scores,
        :judging_round,
        student_survey_link: [:text, :url],
        mentor_survey_link: [:text, :url],
      )
    end

    def signup_scopes
      %w{student mentor judge regional_ambassador}.map { |s| "#{s}_signup" }
    end

    def dashboard_text_scopes
      %w{student mentor judge}.map { |s| "#{s}_dashboard_text" }
    end
  end
end
