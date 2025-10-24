module Admin
  class SeasonScheduleSettingsController < AdminController
    def show
      render json: SeasonTogglesSerializer.new(SeasonToggles).serialized_json
    end

    def update
      SeasonToggles.configure(season_toggle_params)
      redirect_to admin_dashboard_path,
        success: "Season schedule saved!"
    end

    private

    def season_toggle_params
      params.require(:season_toggles).permit(
        *signup_scopes,
        *dashboard_text_scopes,
        :team_building_enabled,
        :team_submissions_editable,
        :select_regional_pitch_event,
        :create_regional_pitch_event,
        :add_teams_to_regional_pitch_event,
        :display_scores,
        :judging_round,
        student_survey_link: [:text, :long_desc, :url],
        mentor_survey_link: [:text, :long_desc, :url]
      )
    end

    def signup_scopes
      %w[student mentor judge chapter_ambassador].map { |s| "#{s}_signup" }
    end

    def dashboard_text_scopes
      %w[student mentor judge chapter_ambassador].map { |s| "#{s}_dashboard_text" }
    end
  end
end
