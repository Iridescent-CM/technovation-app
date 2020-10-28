module Admin
  class SurveyPopupResetsController < AdminController
    def create
      scope = "#{params[:scope]}_profile".to_sym
      Account
        .joins(scope)
        .update_all(
          reminded_about_survey_at: nil,
          reminded_about_survey_count: 0,
          pre_survey_completed_at: nil
        )

      render json: {}
    end
  end
end
