class AddRemindedAboutSurveyAtToAccounts < ActiveRecord::Migration[5.1]
  def change
    add_column :accounts, :reminded_about_survey_at, :datetime
  end
end
