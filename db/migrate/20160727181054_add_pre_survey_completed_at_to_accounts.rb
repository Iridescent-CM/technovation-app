class AddPreSurveyCompletedAtToAccounts < ActiveRecord::Migration[4.2]
  def change
    add_column :accounts, :pre_survey_completed_at, :datetime
  end
end
