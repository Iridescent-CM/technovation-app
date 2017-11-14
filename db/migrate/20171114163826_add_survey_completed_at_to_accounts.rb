class AddSurveyCompletedAtToAccounts < ActiveRecord::Migration[5.1]
  def change
    add_column :accounts, :survey_completed_at, :datetime
  end
end
