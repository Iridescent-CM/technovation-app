class SurveyCompletionsController < ApplicationController
  include Authenticated

  def show
    current_account.took_survey!
    redirect_to send("#{current_scope}_dashboard_path"),
      success: "Thank you for taking our survey!"
  end

  private
  def current_scope
    current_account.scope_name
  end
end
