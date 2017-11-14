module SurveyReminderController
  extend ActiveSupport::Concern

  def create
    current_account.reminded_about_survey!
    head 200
  end
end
