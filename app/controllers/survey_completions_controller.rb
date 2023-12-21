class SurveyCompletionsController < ApplicationController
  include Authenticated

  def show
    current_account.took_program_survey!
    redirect_to send("#{current_account.scope_name}_dashboard_path"),
      success: "Thank you for taking our survey!"
  end

  private

  def current_scope
    current_account.scope_name
  end
end
